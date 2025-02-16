//
//  StaticDefaultValues.swift
//  Bythen
//
//  Created by edisurata on 14/10/24.
//

import Foundation

class StaticDefaultValues {
    static let staticStickersJson = """
    {
        "enabled": false,
        "stickers": [{
            "image_url": "https://assets-staging.bythen.ai/dojo/onboarding/sticker-1.png",
            "leading": 210,
            "trailing": 0,
            "top": -70,
            "bottom": 0
        },{
            "image_url": "https://assets-staging.bythen.ai/dojo/onboarding/sticker-2.png",
            "leading": 160,
            "trailing": 0,
            "top": 140,
            "bottom": 0
        },{
            "image_url": "https://assets-staging.bythen.ai/dojo/onboarding/sticker-3.png",
            "leading": -130,
            "trailing": 0,
            "top": 0,
            "bottom": 0
        }],
        "animation": {
            "enabled": false,
            "duration": 1,
            "offset": 5
        }
    }
    """

    static let staticVoiceTagsJson = """
    {
      "base": [
        {
          "value": "masculine",
          "label": "masculine"
        },
        {
          "value": "feminine",
          "label": "feminine"
        },
        {
          "value": "androgynous",
          "label": "androgynous"
        }
      ],
      "accents": [
        {
          "value": "american",
          "label": "american"
        },
        {
          "value": "british",
          "label": "british"
        },
        {
          "value": "african",
          "label": "african"
        },
        {
          "value": "indian",
          "label": "indian"
        },
        {
          "value": "australian",
          "label": "australian"
        }
      ],
      "age": [
        {
          "value": "young",
          "label": "young"
        },
        {
          "value": "middle-aged",
          "label": "middle-aged"
        },
        {
          "value": "old",
          "label": "old"
        }
      ]
    }
    """

    static let staticDialogueStylePresetsJson = """
    {
        "data": [
            {
                "label": "Daily conversations",
                "value": "Daily conversations"
            },
            {
                "label": "Movie quotes",
                "value": "Movie quotes"
            },
            {
                "label": "Internet memes",
                "value": "Internet memes"
            },
            {
                "label": "Comedy monologues",
                "value": "Comedy monologues"
            },
            {
                "label": "Song lyrics",
                "value": "Song lyrics"
            },
            {
                "label": "Professional phrases",
                "value": "Professional phrases"
            },
            {
                "label": "American slang.",
                "value": "American slang."
            },
            {
                "label": "British slang. ",
                "value": "British slang. "
            },
            {
                "label": "Millennial slang. ",
                "value": "Millennial slang. "
            },
            {
                "label": "Gen-z slang.",
                "value": "Gen-z slang."
            }
        ]
    }
    """

    static let staticPersonalitiesJson = """
    {
        "data": [
            {
                "min_label": "Introvert",
                "min_value": 1,
                "max_label": "Extrovert",
                "max_value": 5
            },
            {
                "min_label": "Agreeable",
                "min_value": 1,
                "max_label": "Critical",
                "max_value": 5
            },
            {
                "min_label": "Lively",
                "min_value": 1,
                "max_label": "Calm",
                "max_value": 5
            },
            {
                "min_label": "Spontaneous",
                "min_value": 1,
                "max_label": "Organized",
                "max_value": 5
            },
            {
                "min_label": "Open",
                "min_value": 1,
                "max_label": "Conventional",
                "max_value": 5
            },
            {
                "min_label": "Apathy",
                "min_value": 1,
                "max_label": "Empathetic",
                "max_value": 5
            }
        ]
    }
    """

    static let staticMinimumAppVersionJson = """
        {"minimum_version": "1.0.0"}
    """

    static let staticHiveRankRulesJson = """
    {
      "commisions": {
        "inactive": {
          "direct_commision": "",
          "passup_commision": "",
          "pairing_commision": "",
          "general_comission": "",
          "frame_url": "https://assets.bythen.ai/hive/frames/inactive.png",
          "show_star": false
        },
        "1": {
          "direct_commision": "11%",
          "passup_commision": "",
          "pairing_commision": "UP TO 4.5%",
          "general_comission": "Get up to 200% more rewards",
          "frame_url": "https://assets.bythen.ai/hive/frames/new-bee.png",
          "show_star": false
        },
         "2": {
          "direct_commision": "15%",
          "passup_commision": "",
          "pairing_commision": "UP TO 4.5%",
          "general_comission": "Get up to 120% more rewards",
          "frame_url": "https://assets.bythen.ai/hive/frames/worker-bee.png",
          "show_star": false
        },
         "3": {
          "direct_commision": "22%",
          "passup_commision": "11%",
          "pairing_commision": "UP TO 7.5%",
          "general_comission": "",
          "frame_url": "https://assets.bythen.ai/hive/frames/royal-bee.png",
          "show_star": true
        }
      },
      "rules": {
        "1": {
          "beacon_point": 1,
          "icon_url": "https://assets.bythen.ai/hive/bees/new-bee-icon.png",
          "show_star": false,
          "tier_name": "New Bee",
          "bonus_caption": "11% Direct Bonus\nâ‰¤ 4.5% Pairing Bonus"
        },
        "4":{
          "beacon_point": 4,
          "icon_url": "https://assets.bythen.ai/hive/bees/worker-bee-icon.png",
          "show_star": false,
          "tier_name": "Work Bee",
          "bonus_caption": "15% Direct Bonus\nâ‰¤ 4.5% Pairing Bonus"
        },
        "10":{
          "beacon_point": 10,
          "icon_url": "https://assets.bythen.ai/hive/bees/royal-bee-icon.png",
          "show_star": true,
          "tier_name": "Royal Bee",
          "bonus_caption": "22% Direct Bonus\nâ‰¤ 7.5% Pairing Bonus"
        }
      },
      "max_slot": 10
    }
    """
    
    static let defaultHiveOnboardingJson = """
    {
        "video_url": "https://storage.bythen.ai/onboarding-video-7438997e.mp4",
        "telegram_group": "https://t.me/+euhKEENksJoyYTY9"
    }
    """
}
