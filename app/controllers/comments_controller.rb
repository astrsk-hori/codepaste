class CommentsController < ApplicationController
  before_action :set_comment, only: [:update, :destroy]
  before_action :is_my_comment?, only: [:update, :destroy]

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @page = Page.find_by(id: params[:page_id])
    @page.comments << @comment

    respond_to do |format|
      if @page.save
        format.html { redirect_to page_path(@comment.page_id), notice: 'comment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @comment }
      else
        flash[:error] =  "comment was Error."
        format.html { redirect_to page_path(@comment.page_id) }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to page_path(id: params[:page_id]) }
      format.json { head :no_content }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:comment, :page_id)
    end

    def set_comment
      @comment = Comment.where(page_id: params[:page_id]).find_by(id: params[:id])
    end

    def is_my_comment?
      if @comment.user.present? && @comment.user_id != current_user.id
        flash[:error] =  "permission denied."
        redirect_to comments_path
      end
    end
end
