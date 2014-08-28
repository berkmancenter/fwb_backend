require 'find'
require 'rdf/nquads'
require 'date'

module CWB
  class Project < CWB::Resource
    # when passed to .all, :uri is a sparql variable
    # when passed to .each(:project_id), uri is the URI for the project
    def self.graph_pattern(uri=nil,name=nil,description=nil,path=nil)
      [
        [uri||:uri, RDF.type, PIM.Project],
        [uri||:uri, RDF::DC.title, name||:name],
        [uri||:uri, RDF::DC.description, description||:description],
        [uri||:uri, PIM.path, path||:path]
      ]
    end

    def self.project_init(params)
      CWB::Project.create(params)
      project_dir = params[3]
      project = params[0]

      Find.find(Pathname(project_dir).to_s) do |path|
        next if path.eql? project_dir

        path = Pathname(path)
        rel_path = Pathname(path.to_s[(project_dir.to_s.size+1)..-1])
        is_toplevel = rel_path.parent.to_s.eql?('.')

        uri = RDF::URI('file:/' + rel_path.to_s)
        name = ::File.basename(path.to_s)

        next if is_toplevel && !path.directory? # we don't support files in the root directory
        next if rel_path.basename.to_s == '.DS_Store' # ignore Mac OS X artifacts
        next if rel_path.basename.to_s == 'Thumbs.db' # ignore Windows artifacts

        if ::File.ftype(path) == 'directory' && path.parent.to_s != '.'
          parent = is_toplevel ? '_null' : rel_path.parent.to_s

          params = [project,uri,name,rel_path.to_s,parent]
          CWB::Folder.create(params)
        elsif ::File.ftype(path) == 'file'
          folder = 'file:/'  + ::File.basename(::File.expand_path("..", path.to_s)).to_s
          created = ::File.ctime(path.to_s).to_datetime.to_s
          size = ::File.size(path.to_s).to_s
          type = FileMagic.new.file(path.to_s)
          modified = ::File.mtime(path.to_s).to_datetime.to_s

          params = [project,uri,name,rel_path.to_s,created,size,type,folder,modified]
          CWB::File.create(params)
        end
      end
    end
  end
end
