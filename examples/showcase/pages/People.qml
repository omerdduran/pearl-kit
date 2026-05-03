import QtQuick
import PearlKit 1.0

ShowcasePage {
    title: "People"
    subtitle: "Avatars and identity-bearing rows."
    gridPreset: "four-col"

    ShowcaseTile {
        label: "Avatar — initials"
        Avatar {
            initials: "OD"
        }
    }
    ShowcaseTile {
        label: "Avatar — image"
        Avatar { }
    }
    ShowcaseTile {
        label: "AvatarStack"
        AvatarStack { }
    }
    ShowcaseTile {
        label: "ProfileHeader"
        ProfileHeader {
            width: 320
        }
    }
    ShowcaseTile {
        label: "SubjectRow"
        SubjectRow {
            width: 320
        }
    }
}
