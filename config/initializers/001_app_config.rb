APP_CONFIG = YAML.load_file(Rails.root.join('config/config.yml'), aliases: true)[Rails.env]
