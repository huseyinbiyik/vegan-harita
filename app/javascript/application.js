// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import "chartkick"
import "Chart.bundle"
import "trix"
import "@rails/actiontext"



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

