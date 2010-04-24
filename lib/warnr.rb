require 'active_record'

module Warnr

  # Patches ActiveRecord to:
  # * Store a list of 'warning' fields
  # * Store a list of callbacks for 'after save, if warnings exist'
  # * Store a list of warning messages
  # * Move messages out of the errors object if they belong in the warning object
  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      class_inheritable_accessor :warnr_warning_fields
      self.warnr_warning_fields = []
      define_callbacks :on_save_with_warnings
      attr_reader :warnings
      after_initialize :setup_warnr_warnings
      alias_method_chain 'valid?', 'warnr'
    end
  end
  
  module ClassMethods
    
    # Specify a list of fields to work on.
    # Validation errors on these fields will be ignored.
    def treat_validation_errors_as_warnings_on(*fields)
      self.warnr_warning_fields = self.warnr_warning_fields | fields
    end
    
    # Pass a method name; sets up a callback which runs after create_or_update.
    def on_save_with_warnings(method)
      set_callback(:on_save_with_warnings, :after, method)
    end
    
  end
  
  private
  
  def create_or_update # :nodoc:
    super
    run_callbacks :on_save_with_warnings if errors.empty? and not warnings.empty?
  end
  
  def setup_warnr_warnings # :nodoc:
    @warnings = ActiveModel::Errors.new(self)
  end
  
  # Ugly hack; rather than preventing errors getting added, we move them afterwards.
  # Alternative may be to modify the ActiveModel validation base class 
  # so that it passes a record proxy to the validations that can then decide
  # whether to return the errors or warnings collection when record.errors is called.
  def move_errors_to_warnings
    self.class.warnr_warning_fields.each do |field|
      if errors[field]
        errors[field].each { |error| warnings.add(field, error) }
        errors.delete(field)
      end
    end
  end
end

module ActiveRecord::Validations::InstanceMethods
  # Using alias_method_chain (ugly!) to wrap the valid? method.
  def valid_with_warnr?( *args ) 
    warnings.clear
    
    valid_without_warnr?
    
    # WARNR: Moves any warning-level validation errors to the warnings collection
    move_errors_to_warnings
    # WARNR: Runs warning block if defined
    run_callbacks :on_save_with_warnings if errors.empty? and not warnings.empty?

    errors.empty?
  end
end

ActiveRecord::Base.class_eval do
  include(Warnr)
end

