class CWB::Term < CWB::Resource
  PATTERN = [
    [:resource, RDF.type, PIM.Term],
    [:resource, PIM.project, :project],
  ].freeze

  def self.each(scope_id = nil, &block)
    self.resources(scope_id).each(&block)
  end

  def self.find(id, scope_id = nil)
    self.resources(scope_id).find { |resource| resource['id'].to_s == id }
  end

  def self.resources(project_id = nil)
    resources = JSON.load(File.read(Rails.root.join('app/fixtures/term_fixtures.json')))
    resources.each do |resource|
      resource[:project] = project_id
    end
    resources
  end

  def to_hash
    super.merge({
      project: @project.to_s,
    })
  end
end
