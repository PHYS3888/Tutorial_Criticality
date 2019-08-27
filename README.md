# Tutorial: Criticality

_Acknowledgement_: This tutorial is based on material developed by [Brandon Munn](https://github.com/Bmunn).

## Part 1: Snap, Crackle, and Pop

Most systems snap, crackle, or pop when driven slowly by an external force.
___Pops___ are lots of similarly sized discrete events, like popcorn popping as it is heated.
___Snaps___ are single significant events, like a snapped pencil.
Between these two limits, ___crackles___ are discrete events of a variety of sizes.

Many systems crackle, like the earth responding with intermittent and variable earthquakes from the movement of the tectonic plates, magnetic domains aligning due to an applied magnetic field and the sound of fire crackling.

![](img/snapcracklepop.png)

The crackling material we are investigating today is a material you would be very familiar with: paper.
Hold up some paper to your ear (preferably not your lecture notes) and slowly move it and you will hear audible crackles due to the crumpling.

While paper might appear to be a boring system, we will see that it actually resembles the same types of microscopic random spatial processes we've been studying in lectures, that give rise to characteristic scale-free statistics at the macroscopic scale.

#### Why does paper crackle?
Paper is a thin sheet which bends more easily than it stretches and naturally (and in response to stress) possesses a shape with zero Gaussian curvature almost everywhere.
However, when paper is crumpled (experiences extreme stress), it forms permanent creases.
Crackles are produced from areas of paper buckling under the applied stress.
You can imagine a microscopic model of paper in which the fibers that make up the sheet of paper vary in strength.
When you apply stress to the paper, it will preferentially form creases along contiguous stretches of the weaker fibers.
We've seen plenty of spatial models in lectures where these types of random microscopic processes yield scale-free macroscopic statistics.

Unfold a crumpled piece of paper, and you will find the creases exhibit wildly varying lengths.
Like the sizes of the crumples, the crackles (discrete events) span many orders of magnitude in size.
In this tutorial, we may find that they form a scale-free powerlaw.

![](img/paper_scaleFree.png)

### Recording sound

Measuring the size of lots of individual creases is difficult, but luckily they leave an auditory signature.
To begin our investigation of crackling noise, we will use the `recordsound` function:
```matlab
numSeconds = 10;
[audioData,fs] = recordsound(numSeconds);
```
The audio will be saved as `audioData`, along with the sampling rate, `fs`.

Test this function out: record members of your group speaking for 10 seconds.
Then you can visualise the audio:
```matlab
f = figure('color','w');
plot((1:length(audioData))./fs,audioData)
xlabel('Time (s)')
ylabel('Amplitude')
```

Zoom in and inspect the structure.

Now record 10s of crumpling a piece of paper (slowly!) near the microphone, and plot it as above.
What are the differences between your speech and the paper crumpling?
Are the discrete crackles discernible as separate events in time, or do they overlap?
Is there any evidence paper may crackle (instead of popping or snapping)?

Discuss with your group what distribution of event sizes you expect.

### Discerning crackles

To adequately piece together a scale-free distribution of events, we need many samples of different events.
Through experimenting, we have found that you will need around 40s of paper crumpling to get adequate statistics.
To ensure the microphone can detect each individual crackle, try to crumple your paper slowly to minimize overlapping events.

The energy of a crackle is proportional to its amplitude squared.
The `energyCalc` function performs two steps:
1. Identify crackling events, which we estimate to occur when there is a local maximum in time, implemented using the `findpeaks` function.
2. Calculate the energy of each event as its amplitude squared.

Use `energyCalc` to process your recorded audio into a set of event energies, `E`.

We can now test for evidence of scale-free distribution of event sizes, `E`!
Calculate the histogram of energy crackles:
```matlab
tbl = tabulate(E);
f = figure('color','w');
plot(tbl(:,1),tbl(:,2),'ok')
```
What do you notice?

Now plot the same histogram on a log-log scale.
When plotting on log-log axes, it is good practice to use logarithmically spaced bins.
This can be achieved using the following commands:
```matlab
numBins = 25;
binEdges = logspace(log10(min(E)),log10(max(E)),numBins);
[N,binEdges] = histcounts(E,binEdges);
```

Plot the distribution determined by the counts, `N` on a log-log plot.

1. You may wish to plot as a function of `binCenters`, the mean of the edges of each bin.
2. Play with the number of bins, selecting a value that best captures the trade-off between spatial resolution of bins and noise of counts in individual bins.
3. You may wish to normalize the counts to probabilities: `Nnorm = N/sum(N)`.
4. You may wish to filter out some bad bins before plotting by constructing a logical index of bins to retain.
We are only interested in plotting bins containing at least one event (`keepBins = (N > 0)`).
The first bin is often contaminated by noise, and can be removed as `keepBins(1) = false`.

:question::question::question:
Does your histogram provide evidence for scale-free powerlaw statistics of paper crumpling events?
Upload your best result as a `.png`, noting any details of the paper, crumpling strategy, and recording length in the figure title (or as text annotations on the figure).

### Universality
Recall the concept of universality from lectures, where diverse systems display similar emergent macroscopic behavior.

Discuss within your group what you expect to change for each of the following changes to the experimental details of the crumpling experiment you performed above:

1. __Recording duration__. Does a longer or shorter recording duration, how does this change the histogram of event energies (Hint: use `hold('on')` when plotting for a visual comparison).
2. __Paper type__. Repeat the experiment with a different type of paper (thickness, material, ...)
3. __Hand size/shape, crumpling technique__. Repeat with a different person or crumpling strategy.

Pick a modification from the three categories above, and repeat the experiment making this modification.
How did this experimental change affect your results?
:question::question::question: Upload a figure showing the results of your first experiment and the results of your modification on the same plot.

### Scale invariance

Look at one of your crumpled pieces of paper.
Are all of the creases a similar length scale, or do you see a wide range of length scales?
How do you think these are related to loud scale-invariant cracks?

If the amplitude of crackles is proportional to the crease length of buckled paper, how would you expect your amplitude plot to change with time?
Do you see this in your time plot?

Another way to test this idea, is to impose a characteristic length scale, by pre-creasing our paper and trying to force crackles to result from these creases only.
Here is an example using triangular creases in the paper of a fixed size, imposing a desired length scale of creases along which cracks will occur:

![](img/preCreased.png)

Now when you crumple, make sure to crumple slowly such that the cracks are due to these areas buckling.

How do you explain the difference in crackles heard?
Do your results support your hypothesis?

:question::question::question:
Comment on the changes in log-log distribution of event energies from your pre-creased paper and upload your plot.

:fire::fire::fire: (optional challenge)
Repeat this analysis for a different imposed length scale (e.g., smaller triangles).
Plotting your result on top of the larger-triangle case, assess whether you find a distribution of energies consistent with the smaller imposed crease size.

#### :question::question::question: Is paper sitting at a critical point?

In lectures we learned about self-organised criticality.
Can you explain how the paper arrives at the critical point?
How does paper crackling resemble a self-organized critical system?

### Snap, crackle, and/or pop!
Now that you are knowledgeable about crackling noise, we can answer the question as old as father time himself: _do rice bubbles, snap, crackle, or pop?_
The sound file, `riceBubble.wav`, is a recording of rice bubbles recently after adding milk.

![](img/milkPouring.png)

Load and listen to the file:
```matlab
[riceData,Fs] = audioread(fullfile('data','riceBubble.wav'));
sound(data,Fs);
```
Just from listening, what is your intuition?: _Snap_? _Crackle_? _Pop_?

Because the recording is quite noisy, you will need to set a minimum threshold for each event by editing the `findpeaks` command in `energyCalc`, setting `'MinPeakHeight'` to a small value (e.g., `0.04`).

Now take a look at the histogram of event energies in rice bubbles?
What can you conclude from these plots?

:question::question::question: Upload your plot.

### Tectonic Rubbing
The Earth responds with violent and intermittent earthquakes as two tectonic plates rub past one another.
`earthquakes.wav` is a sound file containing all earthquakes in 1995.
Listening to it, can you discern a crackle?
(_Hint_: slow down the audio playback by changing `fs = 2205`).

![](img/earthquake.gif)
![](img/earthquakeDistribution.png)

Calculate the histogram of earthquake magnitudes
(_Note_: you will have to modify `energyCalc`)

You should find a power-law as earthquakes come in a wide range of sizes, from unnoticeable trembles to catastrophic events as the smaller earthquakes are much more common.
This relationship is called the Gutenberg–Richter law, which states the earthquake magnitude scales with the logarithm of the magnitude of the earthquake (with exponent ~-1).

:question::question::question:
What is the exponent of your powerlaw?

### Universality

In this tutorial, we found a similar distribution of events across multiple decades of scale, in both earthquakes and paper crackling.
But both systems have vastly different micro and macroscopic details.

Recall the concept of universality from lectures.
Do you know why universality occurs?
How is universality useful for understanding different phenomena?
What are the advantages of studying toy models?

#### :fire::fire::fire: (Optional) Challenge: Dependence on Experimental Variables

While I am sure you are carefully crumpling the paper as evenly as possible and likely did not notice a significant difference between different crumplers, hand crumpling is imprecise, irreproducible and introduces a length scale of the system proportional to the size of the crumpler's hand.

Let’s try to create an apparatus that can reproducibly crumple paper between trials.
An example of this could be using two cups of similar size and taping the article to the lids; the crumpling would then be generated by slowly rotating the cups in opposite directions, applying a uniform shear force to the paper.

Using your device repeat the analysis and compare your results with simply crumpling by hand.
Does the device yield a wider distribution of events?
