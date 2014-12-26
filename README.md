fishmusic
=========

Generative music project focused on sonification of fish in an aquarium. Also features a demonstration of the same approach applied to sonification of a painting.

For every frame, we compute the optical flow with respect to the previous frame. Whenever a local peak in the optical flow magnitude exceeds a particular threshold (that is, whenever we detect a fish moving quickly), a musical note is played, with the pitch corresponding to the location and flow direction of the peak and the velocity (or intensity) of the note corresponding to the magnitude. The mapping from position and direction to pitch is defined such that when fish are near one another and move in approximately the same direction, they produce consonant chords.

For demonstration of fish sonification, see `fishMusicDemo.m`. For art, see `artMusicDemo.m`.

Overview of model
=================

The mapping from position and direction to pitch is defined in the following way.

Imagine a diatonic (major, minor, or diminished) triad such as C E G. Assuming octave equivalence, there is exactly one other diatonic triad that can be reached by moving a single voice downward by whole step, E G Bb in our example. If we continue to shift one voice at a time downward by whole step, after 18 triads, we will find ourselves back where we started. We can envision this structure as a loop of pitches, wherein each set of three adjacent pitches is a unique diatonic triad:
```
... A#  C#  E   G#  B   D   F#  A   C   E   G   Bb  D   F   Ab  C   Eb  Gb ...
```

This structure contains exactly 18 of the 36 possible diatonic triads. Already, we notice that nearby triads tend to have clear harmonic relationships with one another. For instance, A C E is the relative minor of C E G, and E G Bb is the functionally similar (in the context of dominant function) diminished chord. However, it lacks the essential dominant-tonic relationship.

A key aspect of Western harmony is the resolution of the dominant tritone. In C major, for instance, the tritone of B and F is expected to resolve to C and E. This tritone occurs in the chord of the leading tone, B D F. Now, let us build another loop of pitches in the way described above, but this time starting with this chord:
```
... B   D#  F#  A   C#  E   G   B   D   F   A   C   Eb  G   Bb  Db  F   Ab ...
```

We align this new structure, the "dominant arpeggio," with the original "tonic arpeggio" such that C E falls between B and F:
```
Dominant arp. ...   B   D#  F#  A   C#  E   G   B   D   F   A   C   Eb  G   Bb  Db  F   Ab ...
Tonic arp.    ... A#  C#  E   G#  B   D   F#  A   C   E   G   Bb  D   F   Ab  C   Eb  Gb   ...
```

The resulting structure has many nice properties, among them being the fact that any selection spanning up to four pitches is satisfied by some key signature, and hence sounds diatonic. In fact, any valid key signature is defined by such a region. A "flip" from a cluster of notes on the dominant arpeggio to the notes in the same region of the tonic arpeggio, or vice versa, will either sound like a tonic to dominant or a dominant to tonic harmonic movement, while a selection of notes from both arpeggios in a certain region may sound like a suspension or other diatonic dissonance of some sort.

To introduce register to the model, we vertically repeat the same structure at octave intervals.
```
...   B   D#  F#  A   C#  E   G   B   D   F   A   C   Eb  G   Bb  Db  F   Ab ... +1 oct.
...   B   D#  F#  A   C#  E   G   B   D   F   A   C   Eb  G   Bb  Db  F   Ab ... +0 oct.
...   B   D#  F#  A   C#  E   G   B   D   F   A   C   Eb  G   Bb  Db  F   Ab ... -1 oct.

... A#  C#  E   G#  B   D   F#  A   C   E   G   Bb  D   F   Ab  C   Eb  Gb   ... +1 oct.
... A#  C#  E   G#  B   D   F#  A   C   E   G   Bb  D   F   Ab  C   Eb  Gb   ... +0 oct.
... A#  C#  E   G#  B   D   F#  A   C   E   G   Bb  D   F   Ab  C   Eb  Gb   ... -1 oct.
```

We can now map from a single bit indicating "dominance" and two real numbers, x indicating pitch and y indicating register, to a concrete musical tone. By increasing the range of x, we may increase the amount of chromaticism and dissonance, and by increasing the range of y, we may increase the broadness of the register of the notes produced, while inconsistency of the dominance bit on simultaneous notes permits a certain diatonic dissonance.

We provide a MATLAB implementation of this model. See `data2Music.m` and `getNote.m`.

The x and y values passed into this model are simply the normalized x and y positions of the peaks in flow, while the dominance bit is determined by whether the flow is in the positive or negative x direction. Thus, we ensure that clusters of fish moving in the same direction will sound basically consonant, and changes in direction trigger functional changes in harmony. By simply changing the range of x, we can vastly alter the chromaticism of the music generated. With a very low range of x, the notes may all emerge from the same tetrachord, whereas with a very high range, the piece could sound fundamentally atonal.
