("5.0".."5.2").each do |version|
  appraise "rails_#{version.tr('.', '_')}" do
    gem "activerecord", "~> #{version}.0"
  end
end
