[("7.0".."7.2"), ("8.0".."8.0")].flat_map(&:to_a).each do |version|
  appraise "rails_#{version.tr('.', '_')}" do
    gem "activerecord", "~> #{version}.0"
    if version < "7.2"
      gem "sqlite3", "~> 1.3"
    end
  end
end
