class KnowledgeConnectionsController < InheritedResources::Base
  belongs_to :guideline
  respond_to :json
end
