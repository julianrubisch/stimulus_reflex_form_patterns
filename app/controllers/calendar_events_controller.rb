class CalendarEventsController < ApplicationController
  include CableReady::Broadcaster

  before_action :set_calendar_event, only: [:show, :edit, :update, :destroy]
  before_action :fetch_dates, only: [:index, :create]

  # GET /calendar_events
  # GET /calendar_events.json
  def index
    @calendar_events = CalendarEvent.where(occurs_at: @date_range).order(:occurs_at).group_by(&:occurs_at_date)
    @calendar_event = CalendarEvent.new
  end

  # GET /calendar_events/1
  # GET /calendar_events/1.json
  def show
  end

  # GET /calendar_events/new
  def new
    @calendar_event = CalendarEvent.new
  end

  # GET /calendar_events/1/edit
  def edit
  end

  # POST /calendar_events
  # POST /calendar_events.json
  def create
    @calendar_event = CalendarEvent.new(calendar_event_params)

    if @calendar_event.save
      @calendar_events = CalendarEvent.where(occurs_at: @date_range).order(:occurs_at).group_by(&:occurs_at_date)
      cable_ready["CalendarEvents"].morph({
                                            selector: "#calendar-grid",
                                            html: CalendarEventsController.render(partial: 'calendar_events/calendar_grid', locals: {dates: @dates, calendar_events: @calendar_events}),
                                            children_only: true})
      # we also have to reset the form
      cable_ready["CalendarEvents"].inner_html({
                                            selector: "#calendar-form",
                                            html: CalendarEventsController.render(partial: "form", locals: { calendar_event: CalendarEvent.new })})

      cable_ready.broadcast
    else
      render :index
    end
  end

  # PATCH/PUT /calendar_events/1
  # PATCH/PUT /calendar_events/1.json
  def update
    respond_to do |format|
      if @calendar_event.update(calendar_event_params)
        format.html { redirect_to @calendar_event, notice: 'Calendar event was successfully updated.' }
        format.json { render :show, status: :ok, location: @calendar_event }
      else
        format.html { render :edit }
        format.json { render json: @calendar_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calendar_events/1
  # DELETE /calendar_events/1.json
  def destroy
    @calendar_event.destroy
    respond_to do |format|
      format.html { redirect_to calendar_events_url, notice: 'Calendar event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calendar_event
      @calendar_event = CalendarEvent.find(params[:id])
    end

    def fetch_dates
      @start_date = Date.current.to_date.beginning_of_month
      @date_range = (@start_date..@start_date.end_of_month)
      @dates = @date_range.to_a
      @dates.prepend(@dates.first - 1) until @dates.first.sunday?
      @dates.append(@dates.last + 1) until @dates.last.saturday?
    end

    # Only allow a list of trusted parameters through.
    def calendar_event_params
      params.require(:calendar_event).permit(:occurs_at, :description, :color)
    end
end
