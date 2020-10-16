import ApplicationController from "./application_controller";

/* This is the custom StimulusReflex controller for the Settings Reflex.
 * Learn more at: https://docs.stimulusreflex.com
 */
export default class extends ApplicationController {
  static targets = ["form"];

  connect() {
    super.connect();
  }

  submit(e) {
    e.preventDefault();
    this.stimulate("SettingsReflex#submit", this.formTarget);
  }
}
