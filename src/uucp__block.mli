(*---------------------------------------------------------------------------
   Copyright (c) 2014 The uucp programmers. All rights reserved.
   SPDX-License-Identifier: ISC
  ---------------------------------------------------------------------------*)

(** Block property and block ranges.

    {b References.}
    {ul
    {- {{:http://www.unicode.org/faq/blocks_ranges.html}The Unicode
    blocks and ranges FAQ}.}} *)

(** {1:blockprop Blocks} *)

type t = [
  | `ASCII
  | `Adlam
  | `Aegean_Numbers
  | `Ahom
  | `Alchemical
  | `Alphabetic_PF
  | `Anatolian_Hieroglyphs
  | `Ancient_Greek_Music
  | `Ancient_Greek_Numbers
  | `Ancient_Symbols
  | `Arabic
  | `Arabic_Ext_A
  | `Arabic_Ext_B
  | `Arabic_Ext_C
  | `Arabic_Math
  | `Arabic_PF_A
  | `Arabic_PF_B
  | `Arabic_Sup
  | `Armenian
  | `Arrows
  | `Avestan
  | `Balinese
  | `Bamum
  | `Bamum_Sup
  | `Bassa_Vah
  | `Batak
  | `Bengali
  | `Bhaiksuki
  | `Block_Elements
  | `Bopomofo
  | `Bopomofo_Ext
  | `Box_Drawing
  | `Brahmi
  | `Braille
  | `Buginese
  | `Buhid
  | `Byzantine_Music
  | `CJK
  | `CJK_Compat
  | `CJK_Compat_Forms
  | `CJK_Compat_Ideographs
  | `CJK_Compat_Ideographs_Sup
  | `CJK_Ext_A
  | `CJK_Ext_B
  | `CJK_Ext_C
  | `CJK_Ext_D
  | `CJK_Ext_E
  | `CJK_Ext_F
  | `CJK_Ext_G
  | `CJK_Ext_H
  | `CJK_Radicals_Sup
  | `CJK_Strokes
  | `CJK_Symbols
  | `Carian
  | `Caucasian_Albanian
  | `Chakma
  | `Cham
  | `Cherokee
  | `Cherokee_Sup
  | `Chess_Symbols
  | `Chorasmian
  | `Compat_Jamo
  | `Control_Pictures
  | `Coptic
  | `Coptic_Epact_Numbers
  | `Counting_Rod
  | `Cuneiform
  | `Cuneiform_Numbers
  | `Currency_Symbols
  | `Cypriot_Syllabary
  | `Cypro_Minoan
  | `Cyrillic
  | `Cyrillic_Ext_A
  | `Cyrillic_Ext_B
  | `Cyrillic_Ext_C
  | `Cyrillic_Ext_D
  | `Cyrillic_Sup
  | `Deseret
  | `Devanagari
  | `Devanagari_Ext
  | `Devanagari_Ext_A
  | `Diacriticals
  | `Diacriticals_Ext
  | `Diacriticals_For_Symbols
  | `Diacriticals_Sup
  | `Dingbats
  | `Dives_Akuru
  | `Dogra
  | `Domino
  | `Duployan
  | `Early_Dynastic_Cuneiform
  | `Egyptian_Hieroglyph_Format_Controls
  | `Egyptian_Hieroglyphs
  | `Elbasan
  | `Elymaic
  | `Emoticons
  | `Enclosed_Alphanum
  | `Enclosed_Alphanum_Sup
  | `Enclosed_CJK
  | `Enclosed_Ideographic_Sup
  | `Ethiopic
  | `Ethiopic_Ext
  | `Ethiopic_Ext_A
  | `Ethiopic_Ext_B
  | `Ethiopic_Sup
  | `Geometric_Shapes
  | `Geometric_Shapes_Ext
  | `Georgian
  | `Georgian_Ext
  | `Georgian_Sup
  | `Glagolitic
  | `Glagolitic_Sup
  | `Gothic
  | `Grantha
  | `Greek
  | `Greek_Ext
  | `Gujarati
  | `Gunjala_Gondi
  | `Gurmukhi
  | `Half_And_Full_Forms
  | `Half_Marks
  | `Hangul
  | `Hanifi_Rohingya
  | `Hanunoo
  | `Hatran
  | `Hebrew
  | `Hiragana
  | `IDC
  | `IPA_Ext
  | `Ideographic_Symbols
  | `Imperial_Aramaic
  | `Indic_Number_Forms
  | `Indic_Siyaq_Numbers
  | `Inscriptional_Pahlavi
  | `Inscriptional_Parthian
  | `Jamo
  | `Jamo_Ext_A
  | `Jamo_Ext_B
  | `Javanese
  | `Kaithi
  | `Kaktovik_Numerals
  | `Kana_Ext_A
  | `Kana_Ext_B
  | `Kawi
  | `Kana_Sup
  | `Kanbun
  | `Kangxi
  | `Kannada
  | `Katakana
  | `Katakana_Ext
  | `Kayah_Li
  | `Kharoshthi
  | `Khitan_Small_Script
  | `Khmer
  | `Khmer_Symbols
  | `Khojki
  | `Khudawadi
  | `Lao
  | `Latin_1_Sup
  | `Latin_Ext_A
  | `Latin_Ext_Additional
  | `Latin_Ext_B
  | `Latin_Ext_C
  | `Latin_Ext_D
  | `Latin_Ext_E
  | `Latin_Ext_F
  | `Latin_Ext_G
  | `Lepcha
  | `Letterlike_Symbols
  | `Limbu
  | `Linear_A
  | `Linear_B_Ideograms
  | `Linear_B_Syllabary
  | `Lisu
  | `Lisu_Sup
  | `Lycian
  | `Lydian
  | `Mahajani
  | `Mahjong
  | `Makasar
  | `Malayalam
  | `Mandaic
  | `Manichaean
  | `Marchen
  | `Masaram_Gondi
  | `Math_Alphanum
  | `Math_Operators
  | `Mayan_Numerals
  | `Medefaidrin
  | `Meetei_Mayek
  | `Meetei_Mayek_Ext
  | `Mende_Kikakui
  | `Meroitic_Cursive
  | `Meroitic_Hieroglyphs
  | `Miao
  | `Misc_Arrows
  | `Misc_Math_Symbols_A
  | `Misc_Math_Symbols_B
  | `Misc_Pictographs
  | `Misc_Symbols
  | `Misc_Technical
  | `Modi
  | `Modifier_Letters
  | `Modifier_Tone_Letters
  | `Mongolian
  | `Mongolian_Sup
  | `Mro
  | `Multani
  | `Music
  | `Myanmar
  | `Myanmar_Ext_A
  | `Myanmar_Ext_B
  | `NB (** Non_block *)
  | `NKo
  | `Nabataean
  | `Nag_Mundari
  | `Nandinagari
  | `New_Tai_Lue
  | `Newa
  | `Number_Forms
  | `Nushu
  | `Nyiakeng_Puachue_Hmong
  | `OCR
  | `Ogham
  | `Ol_Chiki
  | `Old_Hungarian
  | `Old_Italic
  | `Old_North_Arabian
  | `Old_Permic
  | `Old_Persian
  | `Old_Sogdian
  | `Old_South_Arabian
  | `Old_Turkic
  | `Old_Uyghur
  | `Oriya
  | `Ornamental_Dingbats
  | `Osage
  | `Osmanya
  | `Ottoman_Siyaq_Numbers
  | `PUA
  | `Pahawh_Hmong
  | `Palmyrene
  | `Pau_Cin_Hau
  | `Phags_Pa
  | `Phaistos
  | `Phoenician
  | `Phonetic_Ext
  | `Phonetic_Ext_Sup
  | `Playing_Cards
  | `Psalter_Pahlavi
  | `Punctuation
  | `Rejang
  | `Rumi
  | `Runic
  | `Samaritan
  | `Saurashtra
  | `Sharada
  | `Shavian
  | `Shorthand_Format_Controls
  | `Siddham
  | `Sinhala
  | `Sinhala_Archaic_Numbers
  | `Small_Forms
  | `Small_Kana_Ext
  | `Sogdian
  | `Sora_Sompeng
  | `Soyombo
  | `Specials
  | `Sundanese
  | `Sundanese_Sup
  | `Sup_Arrows_A
  | `Sup_Arrows_B
  | `Sup_Arrows_C
  | `Sup_Math_Operators
  | `Sup_PUA_A
  | `Sup_PUA_B
  | `Sup_Punctuation
  | `Sup_Symbols_And_Pictographs
  | `Super_And_Sub
  | `Sutton_SignWriting
  | `Syloti_Nagri
  | `Symbols_And_Pictographs_Ext_A
  | `Symbols_For_Legacy_Computing
  | `Syriac
  | `Syriac_Sup
  | `Tagalog
  | `Tagbanwa
  | `Tags
  | `Tai_Le
  | `Tai_Tham
  | `Tai_Viet
  | `Tai_Xuan_Jing
  | `Takri
  | `Tamil
  | `Tamil_Sup
  | `Tangsa
  | `Tangut
  | `Tangut_Components
  | `Tangut_Sup
  | `Telugu
  | `Thaana
  | `Thai
  | `Tibetan
  | `Tifinagh
  | `Tirhuta
  | `Toto
  | `Transport_And_Map
  | `UCAS
  | `UCAS_Ext
  | `UCAS_Ext_A
  | `Ugaritic
  | `VS
  | `VS_Sup
  | `Vai
  | `Vedic_Ext
  | `Vertical_Forms
  | `Vithkuqi
  | `Wancho
  | `Warang_Citi
  | `Yezidi
  | `Yi_Radicals
  | `Yi_Syllables
  | `Yijing
  | `Zanabazar_Square
  | `Znamenny_Music
  ]
(** The type for blocks. The value [`NB] is for characters that are not
    yet assigned to a block. *)

val compare : t -> t -> int
(** [compare b b'] is [Stdlib.compare b b']. *)

val pp : Format.formatter -> t -> unit
(** [pp ppf b] prints an unspecified representation of [b] on [ppf]. *)

val blocks : (t * (Uchar.t * Uchar.t)) list
(** [blocks] is the list of blocks sorted by increasing range order.
    Each block appears exactly once in the list except
    [`NB] which is not part of this list as it is not a block. *)

val block : Uchar.t -> t
(** [block u] is [u]'s
    {{:http://www.unicode.org/reports/tr44/#Block}Block} property. *)
