%w[6.0 6.1 7.0].each do |version|
  appraise "rails_#{version.tr('.', '_')}" do
    gem "activerecord", "~> #{version}.0"
  end
end
