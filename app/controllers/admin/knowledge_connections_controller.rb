class Admin::KnowledgeConnectionsController < ApplicationController

  before_filter :require_admin

  def create
    @guideline = Guideline.find(params[:guideline_id])
    @connection = @guideline.knowledge_connections.create(params[:knowledge_connection])
    respond_to do |format|
      format.json { render :json => @connection }
    end
  end

  def destroy
    @guideline = Guideline.find(params[:guideline_id])
    @connection = @guideline.knowledge_connections.find(params[:id])
    @connection.destroy
    respond_to do |format|
      format.json { render :json => @connection }
    end
  end
    
end
