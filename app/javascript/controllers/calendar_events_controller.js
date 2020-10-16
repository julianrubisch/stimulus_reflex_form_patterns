import ApplicationController from "./application_controller";

/* This is the custom StimulusReflex controller for the CalendarEvents Reflex.
 * Learn more at: https://docs.stimulusreflex.com
 */
export default class extends ApplicationController {
  static targets = ["form"];
  connect() {
    super.connect();
    // add your code here, if applicable
  }

  submit(e) {
    e.preventDefault();
    this.stimulate("CalendarEventsReflex#submit", this.formTarget);
  }
}
