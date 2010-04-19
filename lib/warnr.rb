module ActiveRecord
  module Validations
    module InstanceMethods
      # Hacking this method to call 'self.handle_ignored_validations'.
      # Ugly, ugly way to do it - anyone got a better idea? (ask the rails core for a mid-validations hook?)
      def valid?
        errors.clear

        @_on_validate = new_record? ? :create : :update
        _run_validate_callbacks

        deprecated_callback_method(:validate)
        
        if new_record?
          deprecated_callback_method(:validate_on_create)
        else
          deprecated_callback_method(:validate_on_update)
        end
        
        self.handle_ignored_validations if self.respond_to? :handle_ignored_validations

        errors.empty?
      end
    end
  end
end
        
module ActiveModel::Validations

  module ClassMethods
    def when_validation_fails(options, &block)
      raise "hell" unless (options[:on] or options[:treat_as_warnings])
      handle_ignored_proc = Proc.new {
        self.class.on_validation_errors.each do |options|
          if options[:treat_as_warnings]
            options[:treat_as_warnings].each do |field|
              self.warnings[field] = self.errors[field] if self.errors[field]
              self.errors.delete(field)
            end
          end
        end
        self.class.on_validation_errors.each do |options|
          # If there are errors on any of the specified fields, call the block
          fields = ((options[:on] || []) + (options[:treat_as_warnings] || []))
          if fields.detect {|field| errors[field] or warnings[field] }
            block.call(self)
          end
          # Remove errors that we've been asked to ignore.

        end # each call to when_validation_fails
      }
      self.class_eval do
        cattr_accessor :on_validation_errors
        self.on_validation_errors ||= []
        self.on_validation_errors.push(options)
        
        def warnings
          @warnings ||= ActiveModel::Errors.new(self) 
        end
      end # Finish class_eval!
      define_method :handle_ignored_validations, &handle_ignored_proc
    end # when_validation_fails
  end # ClassMethods
  
  # Runs all the specified validations and returns true if no errors were added otherwise false.
  def valid?
    errors.clear
    _run_validate_callbacks
    self.handle_ignored_validations if self.respond_to? :handle_ignored_validations
    errors.empty?
  end

end