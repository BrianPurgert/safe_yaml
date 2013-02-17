monkeypatch = <<-EORUBY
  class Node
    def safe_transform
      if self.type_id
        return unsafe_transform if SafeYAML::OPTIONS[:whitelisted_tags].include?(self.type_id)
        raise "Unknown YAML tag '" + self.type_id + "'" if SafeYAML::OPTIONS[:raise_on_unknown_tag]
      end

      SafeYAML::SyckResolver.new.resolve_node(self)
    end

    alias_method :unsafe_transform, :transform
    alias_method :transform, :safe_transform
  end
EORUBY

if defined?(YAML::Syck::Node)
  YAML::Syck.module_eval monkeypatch
else
  Syck.module_eval monkeypatch
end
