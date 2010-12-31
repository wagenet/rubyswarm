module RackTestMixin

  def self.included(base)
    base.class_eval do
      alias_method :orig_env, :env
      def env
        orig_env.merge(hacked_env)
      end
    end
  end

  # This is where we save additional entries.
  def hacked_env
    @hacked_env ||= {}
  end

  # Override the method to merge additional headers.
  # Plus this implicitly makes it public.
  def env
    super.merge(hacked_env)
  end

end

Capybara::Driver::RackTest.send :include, RackTestMixin

module SpecHelpers

  def add_headers(headers)
    page.driver.hacked_env.merge!(headers)
  end

  def remove_header(header)
    page.driver.hacked_env.delete(header)
  end

  def reset_headers
    page.driver.hacked_env.clear
  end

end
