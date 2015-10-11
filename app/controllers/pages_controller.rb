require 'open-uri'
require 'net/http'

require 'base64'

class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  # GET /pages
  # GET /pages.json
  def index
    @pages = Page.all
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  # GET /pages/1/edit
  def edit
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: 'Page was successfully created.' }
        format.json { render :show, status: :created, location: @page }
      else
        format.html { render :new }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def update
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to @page, notice: 'Page was successfully updated.' }
        format.json { render :show, status: :ok, location: @page }
      else
        format.html { render :edit }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to pages_url, notice: 'Page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /pages/content
  def content
    @content = nil

    Timeout::timeout( 2 ) {
      @content = open( page_params[ :url ], {
        redirect: true,
        'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
        #'Accept-Encoding' => 'gzip,deflate', # added automatically by Net::HTTP
        'Accept-Language' => 'en-US,en;q=0.8',
        'Connection' => 'close',
        'User-Agent' => 'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36',
      } ).read.encode

      doc = Nokogiri::HTML( @content )
      doc.css( 'style,script' ).remove
      @content = doc.to_html #HTMLEntities.new.decode( doc.to_html )
    }

    respond_to do |format|
      format.html {
        render partial: 'pages/content', object: @content
      }
      format.json {
        render json: { source_text: @content }
      }
    end
  end

  # POST /pages/onebit
  def onebit
    content_base64 = page_params[ :cache_image ].split( ',' )[1]
    content_data = Base64.decode64 content_base64
    content_filename = Dir::Tmpname.make_tmpname ['/tmp/onebit','.png'], nil
    File.open( content_filename, 'wb' ) { |f|
      f.write content_data
    }

    %x[convert #{content_filename} -monochrome -depth 1 -type Bilevel #{content_filename}]

    content_data = File.binread( content_filename )
    content_base64 = Base64.strict_encode64 content_data

    render text: "data:image/png;base64,#{content_base64}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:url, :content, :cache_text, :cache_image)
    end
end
