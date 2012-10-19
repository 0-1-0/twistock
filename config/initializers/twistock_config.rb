class Settings
  def self.method_missing(sym, *args, &block)
    return false
  end

  def self.reload
    raw_config = File.read("#{::Rails.root.to_s}/config/settings.yml")
    erb_config = ERB.new(raw_config).result
    settings = YAML.load(erb_config)[::Rails.env]

    if settings
      settings.each { |name, value|
        instance_variable_set("@#{name}", value)
        self.class.class_eval { attr_reader name.intern }
      }
    end
  end

  reload
end