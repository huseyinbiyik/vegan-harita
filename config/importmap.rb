# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "chartkick", to: "chartkick.js"
pin "Chart.bundle", to: "Chart.bundle.js"

# These are all for clustering
pin "@googlemaps/markerclusterer", to: "@googlemaps--markerclusterer.js" # @2.5.3
pin "fast-deep-equal" # @3.1.3
pin "kdbush" # @4.0.2
pin "supercluster" # @8.0.1
# These are all for clustering

pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin "quagga" # @0.12.1

# Active Storage Direct Uploads
pin "@rails/activestorage", to: "activestorage.esm.js"
