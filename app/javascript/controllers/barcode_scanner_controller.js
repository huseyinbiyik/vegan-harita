import { Controller } from "@hotwired/stimulus";
import Quagga from "quagga";

// Connects to data-controller="barcode-scanner"
export default class extends Controller {
  static targets = [
    "barcodeField",
    "scanResult",
    "barcodeInput",
    "barcodeForm",
  ];

  connect() {
    this.scan();
  }

  scan() {
    let detectedCode = null;

    if (
      navigator.mediaDevices &&
      typeof navigator.mediaDevices.getUserMedia === "function"
    ) {
      Quagga.init(
        {
          inputStream: {
            name: "Live",
            type: "LiveStream",
            target: this.barcodeFieldTarget,
            locate: true,
            locator: {
              patchSize: "medium",
              halfSample: true,
            },
          },
          decoder: {
            readers: [
              "code_128_reader",
              "ean_reader",
              "upc_reader",
              "code_39_reader",
            ],
          },
        },
        (err) => {
          if (err) {
            console.log("Quagga initialization error:", err);
            return;
          }
          Quagga.start();
        }
      );

      Quagga.onDetected((data) => {
        detectedCode = data.codeResult.code;
        this.barcodeInputTarget.value = detectedCode;

        if (detectedCode) {
          Quagga.stop();
          this.barcodeFormTarget.requestSubmit();
        }
      });
    }
  }

  rescan() {
    Quagga.stop();
    this.scan();
  }

  disconnect() {
    Quagga.stop();
  }
}
