class BlogPostsController < ApplicationController

  before_filter :admin_required, :except=>[:index, :show]

  def add_comment
    @blog_post    = BlogPost.find(params[:id])
    @post_comment = PostComment.new(params[:post_comment])

    @post_comment.blog_post = @blog_post
    @post_comment.user      = current_user
    @post_comment.save

    redirect_to :back
  end

  # GET /blog_posts
  # GET /blog_posts.json
  def index
    if signed_as_admin?
      @blog_posts = BlogPost.all
    else
      @blog_posts = BlogPost.where(:published=>true)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @blog_posts }
    end
  end

  # GET /blog_posts/1
  # GET /blog_posts/1.json
  def show
    @blog_post    = BlogPost.find(params[:id])
    @post_comment = PostComment.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @blog_post }
    end
  end

  # GET /blog_posts/new
  # GET /blog_posts/new.json
  def new
    @blog_post = BlogPost.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @blog_post }
    end
  end

  # GET /blog_posts/1/edit
  def edit
    @blog_post = BlogPost.find(params[:id])
  end

  # POST /blog_posts
  # POST /blog_posts.json
  def create
    @blog_post      = BlogPost.new(params[:blog_post])
    @blog_post.user = current_user

    respond_to do |format|
      if @blog_post.save
        format.html { redirect_to @blog_post, notice: 'Blog post was successfully created.' }
        format.json { render json: @blog_post, status: :created, location: @blog_post }
      else
        format.html { render action: "new" }
        format.json { render json: @blog_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /blog_posts/1
  # PUT /blog_posts/1.json
  def update
    @blog_post = BlogPost.find(params[:id])

    respond_to do |format|
      if @blog_post.update_attributes(params[:blog_post])
        format.html { redirect_to @blog_post, notice: 'Blog post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @blog_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blog_posts/1
  # DELETE /blog_posts/1.json
  def destroy
    @blog_post = BlogPost.find(params[:id])
    @blog_post.destroy

    respond_to do |format|
      format.html { redirect_to blog_posts_url }
      format.json { head :no_content }
    end
  end
end
