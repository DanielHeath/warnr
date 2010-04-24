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
    
    def treat_validation_errors_as_warnings_on(*fields)
      # Specify a list of fields to work on.
      # Validation errors on these fields will be ignored.
      self.warnr_warning_fields = self.warnr_warning_fields | fields
    end
    
    def on_save_with_warnings(method)
      # Pass a method name; sets up a callback which runs after create_or_update.
      set_callback(:on_save_with_warnings, :after, method)
    end
    
  end
  
  def create_or_update # :nodoc:
    super
    run_callbacks :on_save_with_warnings if errors.empty? and not warnings.empty?
  end
  
  def setup_warnr_warnings # :nodoc:
    @warnings = ActiveModel::Errors.new(self)
  end
  
  def move_errors_to_warnings
    # Ugly hack; rather than preventing errors getting added, we just move them afterwards.
    # Would be cleaner to instead patch each of the validation classes but that's a lot more work!
    # Alternative may be to modify the validation base class to pass a record proxy that decides 
    # whether to return the errors or warnings collection from record.errors.
    self.class.warnr_warning_fields.each do |field|
      if errors[field]
        errors[field].each { |error| warnings.add(field, error) }
        errors.delete(field)
      end
    end
  end
end

module ActiveRecord
  module Validations
    module InstanceMethods
      # Haven't figured out how to make the load order work without patching this directly.
      # Please, if you manage - let me know!
      # Looks like alias_method_chain is making things confusing again!
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
  end
end

ActiveRecord::Base.class_eval do
  include(Warnr)
end

