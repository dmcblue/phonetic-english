# phonetic-english
Attempt at a phonetically consisten English orthography

## Goals

- Create a useful system of spelling English that communicates phonetics clearly.
- Create executables that convert between various English spelling standards and new phonetic version.

## Alphabet / Orthography Goals

- Be phonetically consistentet, not necessarily directly phonetic.

For example, `bit` and `bite` represent a consistent way of communicated short and long vowel sounds without being directly phonetic (ie. the `e` in `bite` is no pronounced).

- Attempt to be fairly close to current spelling standards.
- No added characters or accents in order to make typing easy. Which makes adoption easy. No new keyboards, fonts, programs, etc.

## Which English

What makes this project useful and at the same time so difficult is that there is no 'standard' for English.
That is not to say English would benefit from one.
This project does not attempt to create a standard of 'correct' English or even enforce a phonetic scheme, despite being a 'phonetic' spelling system.
Instead, it will attempt to take a common manner of speaking and create a mapping between general pronunciation and spealling.
Many English dialects/accents are consistent one-to-another even if their pronunciation is not the same,
meaning if two words are pronounced similarly in one dialect,
they are generally pronounced similarly in another,
though the pronuniciations themselves may differ.

This similarity is true enough to make the project useful to some degree.

For this project, [General American English](https://en.wikipedia.org/wiki/General_American_English) will be used as a guide.
GA maps well enough to [Received Pronunciation](200~https://en.wikipedia.org/wiki/Received_Pronunciation), a common British standard, that any system based off of it should work for many English speakers across the world.

One major difference between GA and RP that is not easily addressed is the [`ʍ` sound](https://en.wikipedia.org/wiki/Voiceless_labialized_velar_approximant) which is no longer pronounced by most GA speakers. For consistency's sake, this sound should be preserved in the spelling where it occurs in RP.

## Why This Standard

There have been [many attempts](https://en.wikipedia.org/wiki/English-language_spelling_reform) to reform spelling in English,
none have been very successful, for a variety of reasons:

- Too different from current spellings
- Introduction of new letters or diacritics makes the work to update technology a barrier

There is no claim this attempt at a standard will overcome all barriers. It merely will attempt to lessen all those barriers to the maximum extent possible.

## Why Spelling Refom

English speakers are especially known for mangling the names and languages of other peoples.
The latent (and not so latent) xenophobia that dominates many English speaking countries aside,
a major reason for this inability to pronouce written words unfamiliar to the speaker
is the fact that most vowel pronunciation in English must be memorized.

The common example is the pair of words `read` and `read` whose pronunciation and meaning are different, yet their spelling is the same.

Another common example is the letter set `ough` whose pronunciation varies wildly among the words `rough`, `cough`, `through` and `thorough`.

The indication of vowel pronunciation is one of the most needlessly challenging aspects of the English language.
Many spelling reforms focusing on replacing redundant sounds, like `c` with `k` and `s`, or `ph` with `f`, few of these
replacement strategies make English orthography more phonetically 'consistent', as in giving the speaker/reader a better
expectation of how a word should be said.

## What Is Not Addressed

The most obvious item skipped by this project is pronunciations outside of English.
This project does not propose itself to be a stand-in for IPA.
IPA, despite its immense importance and usefulness, is terrible as a writing mechanism.
It is nigh impossible to create a useful way to type in IPA and IPA is largely useless in day to day communication.
One does not need to differentiate between `θ` and `ɸ` in every day English, or in most languages.
Inter-language utility is not directly addressed by this project.
Instead, it is indirectly addressed by making spelling consistent.
Knowing a linguistic context is English should be enough to translate phonology easily and quickly.

http://svn.code.sf.net/p/cmusphinx/code/trunk/cmudict/sphinxdict/cmudict.0.7a_SPHINX_40
