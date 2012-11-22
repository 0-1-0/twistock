class TagController < ApplicationController
  before_filter :load_tag, only: [:update, :destroy]

  def index
    @tags = Tag.all
  end

  def update
    @tag.update_attributes(params[:tag])
    redirect_to tag_index_path
  end

  def create
    @tag = Tag.create(params[:tag])
    redirect_to tag_index_path
  end

  def destroy
    @tag.destroy
    redirect_to tag_index_path
  end

  private

  def load_tag
    @tag = Tag.find(params[:id])
  end
end
