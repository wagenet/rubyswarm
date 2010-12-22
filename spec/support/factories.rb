USERAGENTS = {
  :wino          => { :str => "Mozilla/4.0 (compatible; MSIE 7.0; Windows Phone OS 7.0; Trident/3.1; IEMobile/7.0) Asus;Galaxy6",
                      :version => '7.0', :engine => 'winmo', :os => 'winmo' },
  :msie          => { :str => "Mozilla/5.0 (compatible; MSIE 8.0; Windows NT 5.2; Trident/4.0; Media Center PC 4.0; SLCC1; .NET CLR 3.0.04320)",
                      :version => '8.0', :engine => 'msie', :os => '2003' },
  :konqueror     => { :str => "Mozilla/5.0 (compatible; Konqueror/4.4; Linux) KHTML/4.4.1 (like Gecko) Fedora/4.4.1-1.fc12",
                      :version => '4.4', :engine => 'konqueror', :os => 'linux' },
  :chrome        => { :str => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_5; en-US) AppleWebKit/534.13 (KHTML, like Gecko) Chrome/9.0.597.19 Safari/534.13",
                      :version => '534.13', :engine => 'chrome', :os => 'osx10.6' },
  :webos         => { :str => "Mozilla/5.0 (webOS/1.4.0; U; en-US) AppleWebKit/532.2 (KHTML, like Gecko) Version/1.0 Safari/532.2 Pre/1.0",
                      :version => '1.4.0', :engine => 'webos', :os => 'webos' },
  :android       => { :str => "Mozilla/5.0 (Linux; U; Android 2.2; en-us; Nexus One Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1",
                      :version => '533.1', :engine => 'android', :os => 'android' },
  :s60           => { :str => "Mozilla/5.0 (SymbianOS/9.1; U; [en]; Series60/3.0 NokiaE60/4.06.0) AppleWebKit/413 (KHTML, like Gecko) Safari/413",
                      :version => '3.0', :engine => 's60', :os => 'symbian' },
  :blackberry    => { :str => "BlackBerry9650/5.0.0.732 Profile/MIDP-2.1 Configuration/CLDC-1.1 VendorID/105",
                      :version => '5.0.0.732', :engine => 'blackberry', :os => 'blackberry' },
  :operamobile   => { :str => "Opera/9.80 (S60; SymbOS; Opera Mobi/499; U; en-GB) Presto/2.4.18 Version/10.00",
                      :version => '2.4.18', :engine => 'operamobile', :os => 'symbian' },
  :fennec        => { :str => "Mozilla/5.0 (X11; U; Linux armv7l; en-US; rv:1.9.3a1pre) Gecko/20100531 Namoroka/3.7a1pre Fennec/1.1b1",
                      :version => '1.1b1', :engine => 'fennec', :os => 'linux' },
  :mobilewebkit  => { :str => "Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_1_2 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7D11 Safari/528.16",
                      :version => '528.18', :engine => 'mobilewebkit', :os => 'iphone' },
  :webkit        => { :str => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_8; zh-cn) AppleWebKit/533.18.1 (KHTML, like Gecko) Version/5.0.2 Safari/533.18.5",
                      :version => '533.18.1', :engine => 'webkit', :os => 'osx10.5' },
  :presto        => { :str => "Opera/9.80 (Macintosh; Intel Mac OS X; U; en) Presto/2.2.15 Version/10.00",
                      :version => '2.2.15', :engine => 'presto', :os => 'osx' },
  :gecko         => { :str => "Mozilla/5.0 (Windows; U; Windows NT 6.1; ru; rv:1.9.2.3) Gecko/20100401 Firefox/4.0 (.NET CLR 3.5.30729)",
                      :version => '1.9.2.3', :engine => 'gecko', :os => 'win7' },
  :vista         => { :str => "Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9a7) Gecko/2007080210 GranParadiso/3.0a7",
                      :version => '1.9a7', :engine => 'gecko', :os => 'vista' },
  :winxp         => { :str => "Mozilla/5.0 (Windows; U; Windows NT 5.1; es-ES; rv:1.9.2.10) Gecko/20100914 Firefox/3.6.10 (.NET CLR 3.5.30729)",
                      :version => '1.9.2.10', :engine => 'gecko', :os => 'xp' },
  :win2000       => { :str => "Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.9.0.5) Gecko/2008120122 Firefox/3.0.5",
                      :version => '1.9.0.5', :engine => 'gecko', :os => '2000' },
  :ipod          => { :str => "Mozila/5.0 (iPod; U; CPU like Mac OS X; en) AppleWebKit/420.1 (KHTML, like Geckto) Version/3.0 Mobile/3A101a Safari/419.3",
                      :version => '420.1', :engine => 'mobilewebkit', :os => 'ipod' },
  :ipad          => { :str => "Mozilla/5.0 (iPad; U; CPU OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B334b Safari/531.21.10",
                      :version => '531.21.10', :engine => 'mobilewebkit', :os => 'ipad' },
  :osx104        => { :str => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.1b3pre) Gecko/20090223 SeaMonkey/2.0a3",
                      :version => '1.9.1b3pre', :engine => 'gecko', :os => 'osx10.4' },
  :unknown       => { :str => "Googlebot/2.1 (+http://www.googlebot.com/bot.html)",
                      :version => "unknown", :engine => "unknown", :os => "unknown" }
}

Factory.sequence :email do |n|
  "hello_#{n}@gmail.com"
end

Factory.sequence :useragent do |n|
  "Useragent #{n}"
end

Factory.sequence :version do |n|
  "^#{n}$"
end


Factory.define :client do |f|
  f.association  :user
  f.association  :useragent
  f.os           USERAGENTS[:chrome][:os]
  f.useragentstr USERAGENTS[:chrome][:str]
  f.ip           "127.0.0.1"
end

Factory.define :client_run do |f|
  f.run_id 1
  f.association :client
end

Factory.define :job do |f|
  f.association :user
  f.name "Job"
  f.browsers "popular"
  f.suites "One: http://google.com"
end

Factory.define :run do |f|
  f.association :job
  f.name "Run"
  f.url  "http://google.com"
  f.browsers "popular"
end

Factory.define :user do |f|
  f.email { Factory.next :email }
  f.password "passw0rd"
  f.password_confirmation "passw0rd"
end

Factory.define :useragent do |f|
  f.name { Factory.next :useragent }
  f.engine "chrome"
  f.version { Factory.next :email }
  f.active true
end

Factory.define :useragent_run do |f|
  f.association :run
  f.association :useragent
  f.max 1
end

module SpecHelpers
  %w(
    client
    client_run
    job
    run
    user
    useragent
    useragent_run
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

  def other_user
    @other_user ||= create_user
  end

  def admin_user
    @admin_user ||= create_user(:roles => [admin_role])
  end

  def admin_role
    @admin_role ||= Role.create(:name => 'Admin')
  end

end

