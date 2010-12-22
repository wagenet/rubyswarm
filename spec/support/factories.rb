USERAGENTS = {
  :chrome => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_5; en-US) AppleWebKit/534.13 (KHTML, like Gecko) Chrome/9.0.597.19 Safari/534.13"
}

Factory.sequence :email do |n|
  "hello_#{n}@gmail.com"
end

Factory.define :client do |f|
  f.association :user
  f.association :useragent
  f.os "osx10.6"
  f.useragentstr USERAGENTS[:chrome]
  f.ip "127.0.0.1"
end

Factory.define :client_run do |f|
  f.run_id 1
  f.association :client
end

Factory.define :role do |f|
  f.name "Normal"
end

Factory.define :user do |f|
  f.email { Factory.next :email }
  f.password "passw0rd"
  f.password_confirmation "passw0rd"
  f.roles {|r| [r.association(:role)] }
end

Factory.define :useragent do |f|
  f.name "Chrome"
  f.engine "chrome"
  f.version ".*"
  f.active true
end

module SpecHelpers
  %w(
    client
    client_run
    user
    useragent
  ).each do |model|
    class_eval <<-RUBY
      def build_#{model}(*args)
        Factory.build(:#{model}, *args)
      end

      def create_#{model}(*args)
        Factory.create(:#{model}, *args)
      end

      def attrs_for_#{model}(*args)
        Factory.attributes_for(:#{model}, *args)
      end
    RUBY
  end

  def current_user
    @current_user ||= create_user
  end

end

