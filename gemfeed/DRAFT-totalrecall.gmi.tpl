# TotalRecall: Learning Bulgarian with AI and Anki

> Published at 2025-01-22T10:30:00+02:00

Learning a new language is hard. Learning Bulgarian? That's a special kind of challenge. The Cyrillic script, the complex grammar, the pronunciation - it all adds up. But what if we could leverage AI to make flashcard creation instant and effortless? That's where TotalRecall comes in.

=> https://github.com/yourusername/totalrecall TotalRecall on GitHub

```
 ╔══════════════════════════════╗
 ║  🇧🇬  TOTALRECALL  🧠        ║
 ║  ┌─────────┐  ┌─────────┐   ║
 ║  │ ябълка  │→ │  🍎     │   ║
 ║  │ [audio] │  │ "apple" │   ║
 ║  └─────────┘  └─────────┘   ║
 ╚══════════════════════════════╝
```

<< template::inline::toc

## Why TotalRecall exists

Two motivations drove me to create this tool:

### Learning Bulgarian

I've been fascinated by the Bulgarian language for a while now. It's the oldest written Slavic language, and Sofia has become quite the tech hub. But finding good learning materials? That's tough. Most apps focus on the big languages - Spanish, French, German. Bulgarian gets the short end of the stick.

AnkiDroid has been my go-to for spaced repetition learning. It's powerful, customizable, and works offline. But creating cards manually? That's tedious. Type the word, find an image, record audio, format everything... By the time you've made 10 cards, you're exhausted.

### Practicing agentic coding

The second reason is more technical. I wanted to explore agentic coding - letting AI assistants help write and refactor code. TotalRecall became my playground for this experiment. Could I build something useful while learning how to effectively collaborate with AI coding assistants?

Turns out, yes. The combination of human creativity and AI assistance is powerful. I set the architecture, made design decisions, and the AI helped with implementation details, test writing, and refactoring.

## How it works

TotalRecall is beautifully simple:

```bash
totalrecall "ябълка"
```

That's it. One command, and you get a complete flashcard with everything you need. But there's sophisticated AI magic happening behind the scenes.

### The AI pipeline

When you run that command, TotalRecall orchestrates multiple OpenAI API calls:

1. **Translation** - Bidirectional translation (Bulgarian ↔ English) to understand the word's meaning
2. **Phonetic transcription** - IPA notation for precise pronunciation guidance
3. **Scene description** - AI generates a culturally appropriate scene description for the image
4. **Image generation** - DALL-E creates a memorable visual based on the scene description
5. **Audio synthesis** - High-quality TTS pronunciation that can be regenerated with different voices

All this happens in seconds. The result? A rich, multi-sensory flashcard that engages visual, auditory, and linguistic memory systems.

### Why OpenAI for everything?

I could have used Google Translate for translations, or pulled IPA from Wiktionary. But OpenAI's models understand context. When you input "банка", it knows whether you mean "bank" (financial) or "jar" based on usage patterns. The scene descriptions are culturally aware - Bulgarian bread looks different from American bread, and the AI knows this.

## The science of memorable flashcards

After reading extensively about language learning and memory techniques, I've built TotalRecall to create cards that stick. Here's why our approach works:

### No English on the front

The cards show only Bulgarian text and images - no English translations on the front. This forces your brain to recall meaning from context and imagery, creating stronger neural pathways. When you see "ябълка" with an apple image, your brain learns to connect the Bulgarian word directly to the concept, not to the English word "apple."

### The power of personal connection

The best flashcards include personal context. While TotalRecall generates generic images, I recommend adding your own notes about where you first encountered the word. Did you see "хляб" (bread) at a Bulgarian bakery? Add that story. Personal connections make memories stick. So at will, a custom image prompt (not AI generated) can be specified.

### Sound comes first

Native pronunciation from day one is crucial. That's why every card includes audio. Your brain needs to hear the rhythm and melody of Bulgarian, not your English-accented approximation. The OpenAI voices aren't perfect, but they're leagues better than text-to-speech engines of the past. Plus, you can regenerate audio with different voices if one doesn't sound quite right.

### Images over translations

A picture of bread teaches "хляб" better than the word "bread" ever could. Images bypass linguistic processing and create direct conceptual links. DALL-E generates contextually appropriate images - Bulgarian bread looks different from Wonder Bread, and these cultural nuances matter.

### IPA for precision

The phonetic transcriptions are gold for pronunciation. Bulgarian has sounds that don't exist in English. The IPA shows you exactly where to place your tongue, how to shape your lips. It's the difference between sounding foreign and sounding fluent.

## Spaced repetition: The secret sauce

Anki's algorithm is based on the spacing effect - we remember things better when we review them at increasing intervals. Here's how to maximize it:

### Start small, stay consistent

Don't add 100 words on day one. Start with 10-15 new cards daily. Consistency beats intensity. Your brain needs time to consolidate memories during sleep.

### Review first, add new cards second

Always clear your review queue before adding new cards. Reviews are where the real learning happens. New cards are just seeds - reviews make them grow.

### Trust the algorithm

When Anki says to review a card in 4 months, trust it. The urge to over-review is strong, but it actually weakens memory formation. Let your brain struggle a bit - that's where learning happens.

### Quality over quantity

One well-made card beats ten mediocre ones. TotalRecall ensures quality with:
- Clear, native audio with regeneration options
- Relevant, memorable images from scene-aware descriptions
- IPA transcriptions for pronunciation precision
- Clean, distraction-free formatting

## The technical bits

Written in Go because I wanted something fast and portable. The architecture is clean:

```
internal/
├── audio/     # OpenAI TTS integration
├── image/     # DALL-E image generation
├── anki/      # Card formatting
├── phonetic/  # IPA transcription fetching
├── translation/ # Bidirectional translation
└── config/    # YAML configuration
```

Each package has a single responsibility. The audio package doesn't know about images. The image package doesn't know about Anki. Clean interfaces everywhere.

## Agentic coding insights

Working with AI assistants taught me several valuable lessons:

### Clear communication is crucial

Vague requests get vague results. "Make it better" doesn't work. "Refactor this 80-line function into smaller functions, each handling one responsibility" does. The AI needs specific, actionable instructions.

### AI excels at boilerplate and testing

Writing comprehensive test suites? Perfect AI task. Implementing error handling patterns? Also great. Creative architecture decisions? Still very much a human job. The AI is your implementation partner, not your architect.

### The scaling challenge

Here's the hard truth about agentic coding: it gets exponentially harder as your codebase grows. When TotalRecall was 500 lines, the AI could keep everything in context. At 2000 lines? Not so much.

Features start colliding in unexpected ways. You add batch processing, and suddenly the GUI breaks because it assumes single-word input. You change the default output directory, and it updates in the GUI but not in the CLI batch mode. The AI doesn't see these connections because it can't hold your entire codebase in memory.

### Code duplication becomes a real problem

The AI tends to solve problems locally. Need to validate Bulgarian input? It'll write a validation function right where you need it. Need it again elsewhere? It'll write another one. Before you know it, you have three different ways to validate Cyrillic text.

This isn't the AI being dumb - it's optimizing for the local context you've given it. The burden of architectural consistency falls on you, the human.

### Tests are your safety net

The larger the codebase, the more critical comprehensive tests become. Every time the AI touches code, it might break something three files away. Without tests, you won't know until a user complains.

My rule: before any AI-assisted refactoring, ensure test coverage. The AI is great at writing tests, so use it! Have it write tests for existing code before modifying anything. Then, when it inevitably breaks something, you'll know immediately.

### The context window problem

Modern AI assistants have impressive context windows, but they're not infinite. As TotalRecall grew, I had to become strategic about what context to provide. The entire codebase? Too much. Just the current file? Too little.

The sweet spot: provide the interface definitions, the specific module you're working on, and any directly dependent code. Let the AI know about the broader architecture through comments and documentation, not by dumping everything into context.

So after every feature, clear the context window and/or compact it to start fresh.

## My learning workflow

Here's how I use TotalRecall in practice:

### Morning routine

* Review all due cards in Anki (usually 50-100)
* which includes the review of failed cards
* Add 10-15 new words I encountered yesterday

### Encountering new words

When I find a new Bulgarian word (in articles, videos, conversations):

1. Immediately run `totalrecall "word"`
2. Add personal context in Anki notes
3. Tag it with source (e.g., #news, #conversation)

### Weekly maintenance
- Delete cards for words I'll never use
- Suspend cards I've truly mastered
- Adjust ease factors for consistently hard cards

## Future plans

TotalRecall already packs a lot of features, but I'm planning more:
- Batch processing for word lists
- Support for phrases and sentences
- Grammar pattern recognition
- Integration with Bulgarian dictionaries
- Automatic difficulty scoring based on word frequency
- Multiple image generation options per word
- Voice selection preferences per word

But the real goal? Building a comprehensive Bulgarian deck for AnkiDroid. One command at a time, one word at a time.

## Tips for language learners

### Focus on frequency
Learn the most common 1000 words first. In any language, the top 1000 words cover ~80% of everyday conversation. TotalRecall will eventually include frequency data to help prioritize.

### Use memory palaces
Assign Bulgarian words to locations in your home. Put "хладилник" (refrigerator) on your actual fridge. Spatial memory is incredibly powerful.

### Study before sleep
Review your hardest cards right before bed. Your brain consolidates memories during sleep, especially from the last hour before sleeping.

### Embrace the mess
Language learning is messy. You'll mix up cases, forget words you "knew" yesterday, and butcher pronunciation. That's normal. TotalRecall makes it easy to try again tomorrow.

## Try it yourself

If you're learning Bulgarian (or want to experiment with agentic coding), give TotalRecall a spin:

```bash
go install github.com/yourusername/totalrecall@latest
export OPENAI_API_KEY="your-key"
totalrecall "котка"  # cat
totalrecall "куче"   # dog
totalrecall "вода"   # water
```

Learning languages should be fun, not tedious. Let's make better tools.

E-Mail your comments to `paul@nospam.buetow.org` :-)

Other related posts are:

<< template::inline::rindex language-learning

=> ../ Back to the main site
