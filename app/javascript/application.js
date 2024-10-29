// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import "chartkick";
import "Chart.bundle";
import "trix";
import "@rails/actiontext";
import * as ActiveStorage from "@rails/activestorage";
import { DirectUpload } from "@rails/activestorage";

ActiveStorage.start();

if ("serviceWorker" in navigator) {
  navigator.serviceWorker
    .register("service-worker.js", {
      scope: "./",
    })
    .then((registration) => {
      let serviceWorker;
      if (registration.installing) {
        serviceWorker = registration.installing;
        document.querySelector("#kind").textContent = "installing";
      } else if (registration.waiting) {
        serviceWorker = registration.waiting;
        document.querySelector("#kind").textContent = "waiting";
      } else if (registration.active) {
        serviceWorker = registration.active;
        document.querySelector("#kind").textContent = "active";
      }
      if (serviceWorker) {
        // logState(serviceWorker.state);
        serviceWorker.addEventListener("statechange", (e) => {
          // logState(e.target.state);
        });
      }
    })
    .catch((error) => {
      // Something went wrong during registration. The service-worker.js file
      // might be unavailable or contain a syntax error.
    });
} else {
  // The current browser doesn't support service workers.
  // Perhaps it is too old or we are not in a Secure Context.
}

addEventListener("direct-upload:initialize", (event) => {
  const { target, detail } = event;
  const { id, file } = detail;
  target.insertAdjacentHTML(
    "beforebegin",
    `
      <div id="direct-upload-${id}" class="direct-upload direct-upload--pending">
        <div id="direct-upload-progress-${id}" class="direct-upload__progress" style="width: 0%"></div>
        <span class="direct-upload__filename"></span>
      </div>
    `
  );
  target.previousElementSibling.querySelector(
    `.direct-upload__filename`
  ).textContent = file.name;
});

addEventListener("direct-upload:start", (event) => {
  const { id } = event.detail;
  const element = document.getElementById(`direct-upload-${id}`);
  element.classList.remove("direct-upload--pending");
});

addEventListener("direct-upload:progress", (event) => {
  const { id, progress } = event.detail;
  const progressElement = document.getElementById(
    `direct-upload-progress-${id}`
  );
  progressElement.style.width = `${progress}%`;
});

addEventListener("direct-upload:error", (event) => {
  event.preventDefault();
  const { id, error } = event.detail;
  const element = document.getElementById(`direct-upload-${id}`);
  element.classList.add("direct-upload--error");
  element.setAttribute("title", error);
});

addEventListener("direct-upload:end", (event) => {
  const { id } = event.detail;
  const element = document.getElementById(`direct-upload-${id}`);
  element.classList.add("direct-upload--complete");
});

const input = document.querySelector(
  "input[type=file][data-direct-upload-url]"
);

// Bind to file drop - use the ondrop on a parent element or use a
//  library like Dropzone
const onDrop = (event) => {
  event.preventDefault();
  const files = event.dataTransfer.files;
  Array.from(files).forEach((file) => uploadFile(file));
};

// Bind to normal file selection
input.addEventListener("change", (event) => {
  Array.from(input.files).forEach((file) => uploadFile(file));
  // you might clear the selected files from the input
  input.value = null;
});

const uploadFile = (file) => {
  // your form needs the file_field direct_upload: true, which
  //  provides data-direct-upload-url
  const url = input.dataset.directUploadUrl;
  const upload = new DirectUpload(file, url);

  upload.create((error, blob) => {
    if (error) {
      // Handle the error
    } else {
      // Add an appropriately-named hidden input to the form with a
      //  value of blob.signed_id so that the blob ids will be
      //  transmitted in the normal upload flow
      const hiddenField = document.createElement("input");
      hiddenField.setAttribute("type", "hidden");
      hiddenField.setAttribute("value", blob.signed_id);
      hiddenField.name = input.name;
      document.querySelector("form").appendChild(hiddenField);
    }
  });
};

class Uploader {
  constructor(file, url) {
    this.upload = new DirectUpload(file, url, this);
  }

  uploadFile(file) {
    this.upload.create((error, blob) => {
      if (error) {
        // Handle the error
      } else {
        // Add an appropriately-named hidden input to the form
        // with a value of blob.signed_id
      }
    });
  }

  directUploadWillStoreFileWithXHR(request) {
    request.upload.addEventListener("progress", (event) =>
      this.directUploadDidProgress(event)
    );
  }

  directUploadDidProgress(event) {
    // Use event.loaded and event.total to update the progress bar
  }
}
