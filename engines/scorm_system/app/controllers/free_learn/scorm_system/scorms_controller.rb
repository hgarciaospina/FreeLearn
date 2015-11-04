require_dependency "free_learn/application_controller"

module FreeLearn
  module ScormSystem
  class ScormsController < ApplicationController
    before_action :set_scorm, only: [:show, :edit, :update, :destroy]

    # GET /scorms
    def index
      @scorms = Scorm.all
    end

    # GET /scorms/1
    def show
    end

    # GET /scorms/new
    def new
      @scorm = Scorm.new
    end

    # GET /scorms/1/edit
    def edit
    end

    # POST /scorms
    def create
      @scorm = Scorm.new(scorm_params)

      if @scorm.save
        redirect_to @scorm, notice: 'Scorm was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /scorms/1
    def update
      if @scorm.update(scorm_params)
        redirect_to @scorm, notice: 'Scorm was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /scorms/1
    def destroy
      @scorm.destroy
      redirect_to scorms_url, notice: 'Scorm was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_scorm
        @scorm = Scorm.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def scorm_params
        params[:scorm]
      end
  end
end
end
