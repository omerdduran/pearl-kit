import QtQuick
import PearlKit 1.0

ShowcasePage {
    title: "Sliders & Steppers"
    subtitle: "Bounded numeric inputs and continuous adjusters."
    gridPreset: "two-col"

    ShowcaseTile {
        label: "Slider"
        Slider {
            width: 280
            from: 0
            to: 100
            value: 42
        }
    }
    ShowcaseTile {
        label: "BipolarSlider"
        BipolarSlider {
            width: 280
        }
    }
    ShowcaseTile {
        label: "ReadoutSlider"
        ReadoutSlider {
            width: 280
        }
    }
    ShowcaseTile {
        label: "Stepper"
        Stepper {
            width: 200
            from: 0
            to: 100
            value: 10
        }
    }
    ShowcaseTile {
        label: "DensityBar"
        DensityBar {
            width: 280
        }
    }
}
