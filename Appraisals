("6.0".."6.1").each do |version|
  appraise "activerecord_#{version.tr('.', '_')}" do
    gem "activerecord", "~> #{version}.0"
  end
end

["7.0"].each do |version|
  appraise "activerecord_#{version.tr('.', '_')}" do
    gem "activerecord", "~> #{version}.0"
  end
end
