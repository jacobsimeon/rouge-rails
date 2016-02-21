module Rouge::Rails
  class Configuration
    attr_accessor :default_colorscheme

    def initialize
      @default_colorscheme = :default
    end
  end

  def self.configure
    yield configuration
  end

  def self.configuration
    @config ||= Rouge::Rails::Configuration.new
  end
end
