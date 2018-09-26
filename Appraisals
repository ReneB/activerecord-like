[
  *("5.0.0".."5.0.7"),
  *("5.1.0".."5.1.6"),
  *("5.2.0".."5.2.1")
].each do |version|
  appraise "rails_#{version.tr('.', '_')}" do
    gem "activerecord", version
  end
end
