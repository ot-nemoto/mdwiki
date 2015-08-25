# encoding: utf-8
class PagesController < ApplicationController

  def index
    @url = Url.new
    @url.new = "/mdwiki/new"
    @url.edit = "/mdwiki/edit"
    @url.pagelist = "/mdwiki/tree" if Summary.new('HOME').tree.length > 0
    @page = Page.new('HOME')

    render 'home'
  end

  def tree(id = params[:id])
    Summary.new(id.nil? ? 'HOME' : id) do |s|
      @tree = s.tree
      @breadcrumb = s.breadcrumb
    end
    @id = id

    render :partial => "tree"
  end

  def show(id = params[:id])
    raise ActionController::RoutingError.new('Page Not Found') \
      unless Summary.exists?(id)

    @url = Url.new
    @url.new = "/mdwiki/new/#{id}"
    @url.edit = "/mdwiki/#{id}/edit"
    @url.delete = "/mdwiki/#{id}"
    @url.pagelist = "/mdwiki/tree/#{id}"
    @page = Page.new(id)
    Summary.new(id) do |s|
      @breadcrumb = s.breadcrumb
      @title = s.title
    end

    render 'show'
  end

  def new(parent_id = params[:id])
    if !parent_id.nil?
      raise ActionController::RoutingError.new('ParentPage Not Found') \
        if !Summary.exists?(parent_id)
    end

    @url = Url.new
    @url.cancel = "/mdwiki"; @url.cancel += "/#{parent_id}" unless parent_id.nil?
    @url.save = "/mdwiki/new"; @url.save += "/#{parent_id}" unless parent_id.nil?
    @page = Page.new

    render 'edit'
  end

  def edit_home
    @url = Url.new
    @url.cancel = "/mdwiki"
    @url.save = "/mdwiki/edit"
    @page = Page.new('HOME')

    render 'edit'
  end

  def edit(id = params[:id])
    raise ActionController::RoutingError.new('Page Not Found') \
      unless Summary.exists?(id)

    @url = Url.new
    @url.cancel = "/mdwiki/#{id}"
    @url.save = "/mdwiki/#{id}/edit"
    @page = Page.new(id)

    render 'edit'
  end

  def create(parent_id = params[:id], content = params[:content])
    if !parent_id.nil?
      raise ActionController::RoutingError.new('ParentPage Not Found') \
        if !Summary.exists?(parent_id)
    end

    id = save(Summary.new_id, content, parent_id || 'HOME')

    render :text => "/mdwiki/#{id}"
  end

  def update_home(content = params[:content])
    save('HOME', content)

    render :text => "/mdwiki"
  end

  def update(id = params[:id], content = params[:content])
    raise ActionController::RoutingError.new('Page Not Found') \
      unless Summary.exists?(id)

    save(id, content)

    render :text => "/mdwiki/#{id}"
  end

  def delete(id = params[:id])
    raise ActionController::RoutingError.new('Page Not Found') \
      unless Summary.exists?(id)

    # Delete Summary
    parent_id = Summary.new(id).delete
    # Delete Page
    Page.new(id).delete

    url = "/mdwiki"; url += "/#{parent_id}" if parent_id != 'HOME'
    render :text => url
  end

  def save(id, content, parent_id = nil)
    # Save Summary
    Summary.new(id) do |s|
      s.title = PagesHelper.extract_title(content)
      s.parent_id = parent_id if !parent_id.nil?
      s.save
    end
    # Save Page
    Page.new(id) do |p|
      p.content = content
      p.save
    end

    return id
  end
end
