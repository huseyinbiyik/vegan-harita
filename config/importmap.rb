# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@googlemaps/markerclusterer", to: "https://ga.jspm.io/npm:@googlemaps/markerclusterer@2.0.14/dist/index.esm.js"
pin "fast-deep-equal", to: "https://ga.jspm.io/npm:fast-deep-equal@3.1.3/index.js"
pin "kdbush", to: "https://ga.jspm.io/npm:kdbush@3.0.0/kdbush.js"
pin "supercluster", to: "https://ga.jspm.io/npm:supercluster@7.1.5/index.js"
