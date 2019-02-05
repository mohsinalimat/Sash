//
//  Strings.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 7/30/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation



struct PreferencesLabels {
    static let location = "labels.preferences.location".localized
    
    // prayer times
    static let prayerTimesSection = "labels.preferences.prayerTimes".localized
    
    static let calculationMethod = "labels.preferences.calculationMethod".localized
    static let madhab = "labels.preferences.madhab".localized
    static let highLatitudeRule = "labels.preferences.highLatitudeRule".localized
    static let shiftIntervals = "labels.preferences.adjustments".localized
    
    // notifications
    static let notificationsSection = "labels.preferences.notifications".localized
    static let notificationsIsEnabled = "labels.preferences.notificationsIsEnabled".localized
    static let badgeCountDisplayType = "labels.preferences.badgeCountType".localized

    // more
    static let moreSection = "labels.preferences.more".localized
    
    static let about = "labels.preferences.about".localized
    static let acknowledgements = "labels.preferences.acknowledgements".localized
    static let feedback = "labels.preferences.feedback".localized
}

struct Actions {
    static let contact = "actions.contact".localized
    static let save = "actions.save".localized
}


struct PlaceholdersStrings {
    static let title = "placeholders.title".localized
    static let details = "placeholders.details".localized
}

struct Extras {
    static let smallMinSuffix = "extras.smallMinutes".localized
    static let and = "extras.and".localized
    static let unknown = "extras.unknown".localized
    static let separator = "extras.separator".localized
}

struct Labels {
    
    static let today = "labels.titles.today".localized
    static let calendar = "labels.titles.calendar".localized
    static let reminders = "labels.titles.reminders".localized
    static let about = "labels.titles.about".localized
    
    struct Preferences {
        static let title = "labels.titles.preferences.title".localized
        static let subtitle = "labels.titles.preferences.details".localized
    }

    
    struct PrayerAdjustments {
        static let title = "labels.titles.adjustments.title".localized
        static let subtitle = "labels.titles.adjustments.details".localized
    }
    
    struct NewReminder {
        static let title = "labels.titles.newReminder.title".localized
        static let details = "labels.titles.newReminder.details".localized
        static let placeholder = "labels.titles.newReminder.placeholder".localized
    }
    
    struct Ack {
        static let title = "labels.titles.acks.title".localized
        static let icons = "labels.titles.acks.icons".localized
        static let iconsDetails = "labels.titles.acks.iconsDetails".localized
        static let libraries = "labels.titles.acks.libraries".localized
    }

    struct ReminderDetails {
        static let info = "labels.titles.reminderDetails.info".localized
    }
    
    struct About {
        static let title = "labels.titles.about.title".localized
        static let subtitle = "labels.titles.about.subtitle".localized
        static let contents = "labels.titles.about.contents".localized
    }
}


struct SessionsStrings {
    struct PrayerSelection {
        static let title = "sessions.prayer.title".localized
        static let details = "sessions.prayer.details".localized
    }
    
    struct RepeatDaysSelection {
        static let title = "sessions.repeatDays.title".localized
        static let details = "sessions.repeatDays.details".localized
    }
    
    struct ShiftIntervalSelection {
        static let title = "sessions.shiftInterval.title".localized
        static let details = "sessions.shiftInterval.details".localized
    }
    
    struct CalculationMethodSelection {
        static let title = "sessions.method.title".localized
        static let details = "sessions.method.details".localized
    }
    
    struct MadhabMethodSelection {
        static let title = "sessions.madhab.title".localized
        static let details = "sessions.madhab.details".localized
    }
    
    struct HLRMethodSelection {
        static let title = "sessions.hlr.title".localized
        static let details = "sessions.hlr.details".localized
    }
    
    struct BadgeCountDisplayTypeSelection {
        static let title = "sessions.badgeType.title".localized
        static let details = "sessions.badgeType.details".localized
    }
}

