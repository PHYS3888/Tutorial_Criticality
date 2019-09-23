# Tutorial: Criticality

_Acknowledgement_: This tutorial is based on material developed by [Brandon Munn](https://github.com/Bmunn).

## Part 1: Snap, Crackle, and Pop

Most systems snap, crackle, or pop when driven slowly by an external force.
___Pops___ are lots of similarly sized discrete events, like popcorn popping as it is heated.
___Snaps___ are single significant events, like a snapped pencil.
Between these two limits, ___crackles___ are discrete events of a variety of sizes.

Many systems crackle, like the Earth responding with intermittent and variable earthquakes from the movement of the tectonic plates, magnetic domains aligning due to an applied magnetic field, and the sound of fire crackling.

![](img/snapcracklepop.png)

Physicists have studied the audio profile of crinkling materials, which actually display some surprising and physically interesting properties.
This [New York Times article](https://www.nytimes.com/2000/06/01/us/no-hope-of-silencing-the-phantom-crinklers-of-the-opera.html) describes the physics of disturbing others by unwrapping snacks in the theatre (you should recognize the reference to Universality in this passage):

> "The physics of wrappers turned out to be surprisingly complex, said Dr. Kramer, who found parallels in the different shapes that large protein molecules can assume in the human body and the properties of magnetic materials."

The crackling material we are investigating today is a material you will be very familiar with: paper.
Hold some paper to your ear (preferably not your lecture notes) and slowly move it and you will hear audible crackles due to the crumpling.

While paper might appear to be a boring system, we will see that it actually resembles the same types of microscopic random spatial processes we've been studying in lectures, that give rise to characteristic scale-free statistics at the macroscopic scale.

FYI, here is an example physics paper on the topic, titled ['Acoustic emission from crumpling paper'](https://journals.aps.org/pre/abstract/10.1103/PhysRevE.54.278).

#### Why does paper crackle?
Paper is a thin sheet which bends more easily than it stretches and naturally (and in response to stress) possesses a shape with zero Gaussian curvature almost everywhere.
However, when a paper is crumpled (experiences extreme stress), it forms permanent creases.
Crackles are produced from areas of paper buckling under applied stress.

Imagine a microscopic model of paper in which the fibres that make up the sheet of paper vary in strength.
When you apply stress to the paper, it will preferentially form creases along contiguous stretches of the weaker fibres.
We've seen plenty of spatial models in lectures where these types of random microscopic processes yield scale-free macroscopic statistics.

In fact, you may think of this process as an example of self-organized criticality.
As the paper is bent, the system approaches criticality (this is a slow timescale driving process, like the accumulation of sand in a sand pile).
When it cracks, it quickly dissipates energy (like the redistributive toppling in a sand pile).
Thus, crackling events are the fast dissipation of energy applied to the system.

Unfold a crumpled piece of paper, you will find the creases exhibit wildly varying lengths.
Like the sizes of the crumples, the crackles (discrete events) span many orders of magnitude in size.
In this tutorial, we will (hopefully!) find that they form a scale-free distribution.

![](img/paper_scaleFree.png)

### _PREWORK_: Measure crumpling events as audio

Directly measuring the size of lots of individual creases is difficult, but luckily they leave an auditory signature.
To begin our investigation of crackling noise, we will use the `recordsound` function.
The audio will be saved as `audioData`, along with the sampling rate, `fs`.
Test this function out: record your own speech for 10 seconds, then save the audio (`audioData`) and sampling rate (`fs`) in the `myVoiceData.mat` file:
```matlab
numSeconds = 10;
[audioData,fs] = recordsound(numSeconds);
save('myVoiceData.mat','audioData','fs');
```

You can listen back to your recording as:
```matlab
sound(audioData,fs);
```

You can visualize your recording as:
```matlab
f = figure('color','w');
plot((1:length(audioData))./fs,audioData)
xlabel('Time (s)')
ylabel('Amplitude')
```

Zoom in and inspect the structure of your own voice.
Does it look sensible?

Now, we're ready for the real thing.
Find yourself a piece of paper and get ready to crumple!

To adequately piece together a heavy-tailed distribution of event sizes, we need a large number of samples of different events.
We have found that around 40s of paper crumpling audio is sufficient.
To ensure the microphone can detect each individual crackle, try to crumple your paper slowly to minimize overlapping events, and try to do the crumpling near the microphone to get the best possible signal:

```matlab
numSeconds = 40;
[audioData,fs] = recordsound(numSeconds);
save('myCrumplingData.mat','audioData','fs');
```

Inspect the structure of paper crumpling audio compared to human speech.

What are the differences between your speech and the paper crumpling?
Are the discrete crackles discernible as separate events in time, or do they overlap?
Is there any evidence paper may crackle (instead of popping or snapping)?
What distribution of event sizes do you expect?

Look at one of your crumpled pieces of paper.
The wide range of length scales is related to scale-invariant crackles measured in the audio recording.
If the amplitude of crackles is proportional to the crease length of the buckled paper, how would you expect your crackling amplitudes to change over time?
Do you see this in your time plot?

___Bring these two files: `myVoiceData.mat` and `myCrumplingData.mat` with you to the computer lab.___

---

### _IN-LAB_: Quantifying crackles

The energy of a crackle is proportional to its amplitude squared.
To infer crackling events, we thus need to implement two processing steps:
1. Identify crackling events from the audio data.
We estimate events to occur when there is a local maximum in time (`findpeaks`).
2. Calculate the energy of each event as its amplitude squared.

Look at the `energyCalc` function to verify that it performs these two steps, and then use it to process your recorded audio into a set of event energies, `E`:

```matlab
load('myCrumplingData.mat','audioData','fs')
E = energyCalc(audioData,fs);
```

We're ready to compute the distribution of event energies, `E`!
Use your favorite function to do this (e.g., `histogram` or `tabulate`).
What do you notice?

Now plot the same histogram on logarithmic horizontal and vertical axes.
When plotting on log-log axes, it is good practice to use logarithmically spaced bins, which can be achieved as:
```matlab
numBins = 25;
binEdges = logspace(log10(min(E)),log10(max(E)),numBins);
[N,binEdges] = histcounts(E,binEdges);
```

Plot the distribution determined by the counts, `N`, on a log-log plot (making sure each bin is clearly marked, e.g., plot each data point with a circle and connect consecutive points using `o-k`).

Give thought to the following:

1. You may wish to plot as a function of `binCenters`, the mean of the edges of each bin.
2. Play with the number of bins, selecting a value that best captures the trade-off between spatial resolution of bins and noise of counts in individual bins.
3. You may wish to normalise the counts to probabilities: `Nnorm = N/sum(N)`.
4. You may wish to filter out some bad bins before plotting by constructing a logical index of bins to retain, `keepBins`.
For example, we are only interested in plotting bins containing at least one event (`keepBins = (N > 0)`).
The first bin is often contaminated by noise, and can be removed as `keepBins(1) = false`.
5. You may wish to filter out small events due to background noise, but setting a threshold on the minimum event energy to include in your analysis (e.g., as the `std` of your data).
You can do this by setting the `'minEnergy'` input to `energyCalc` to an appropriately (small) value.

Do you find evidence for a scale-free distribution of event energies from your `myCrumplingData`?

#### One we prepared earlier

Some data that we prepared earlier is in `crackle100s.mat`.
Apply the same processing pipeline you developed above to the data in `crackle100s.mat` and plot both in the same figure.

:question::question::question:
Upload an image of the distribution of event energies for (i) your data, and (ii) the `crackle100s` data.
Put both on the same plot using `hold('on')`.

### Scaling exponent

We saw in lectures that the power-law exponent can be estimated as a linear fit in log-log space.

:question::question::question:
What is the power-law exponent of the event energy distribution recorded in `crackle100s`?

<!-- Upload your best example of the event-energy distribution on a logarithmic scale, noting any details of the paper, crumpling strategy, and recording length in the figure title (or as text annotations on the figure). -->

### Scale dependence

While creases seem to naturally form across a wide range of scales, we can attempt to impose a characteristic spatial scale onto our system by pre-creasing our paper to force crackles to preferentially occur on this characteristic scale.
Here is an example using triangular creases in the paper of a fixed size, imposing the desired length scale of creases along which cracks will occur:

![](img/preCreased.png)

If you have access to a microphone, you can try this experiment now, making sure to crumple slowly such that the cracks are due to these areas buckling.

If not, our results are in `'crackleSimilarSize.mat'`.
Listen to the audio:
```matlab
dataFile = fullfile('data','crackleSimilarSize.mat');
load(dataFile,'yset','fs')
realFs = 1/fs;
sound(yset,realFs);
```

Does this sound like a snap, crackle, or pop?
How do you explain the difference in crackles heard from these data compared to the original data?

Plot the distribution of event energies on log-log axes, as above.

:question::question::question:
What distribution best fits the events in `crackleSimilarSize.mat`?

---

#### :fire::fire::fire: (_Optional_): Another length scale
Repeat the pre-creased experiment for a different imposed length scale (e.g., smaller triangles).
Plot your result on top of the larger-triangle case, and assess whether you find a distribution of crackling energies consistent with the smaller imposed crease size.

#### :fire::fire::fire: (_Optional_): The Ultimate Crumpler  :page_with_curl: :wrench:

While I am sure you are carefully crumpling the paper as evenly as possible and likely did not notice a significant difference between different crumplers, hand crumpling is imprecise, irreproducible and introduces a length scale of the system proportional to the size of the crumpler's hand.

Let’s try to create an apparatus that can reproducibly crumple paper between trials.
An example of this could be using two cups of similar size and taping the article to the lids; the crumpling would then be generated by slowly rotating the cups in opposite directions, applying a uniform shear force to the paper.

Using your device repeat the analysis and compare your results with simply crumpling by hand.
Does the device yield a wider distribution of events?

#### :fire::fire::fire: (_Optional_): Universality
Recall the concept of universality from lectures, where diverse systems display similar emergent macroscopic behavior.

Discuss within your group what you expect to change about the event-energy distribution after making each of the following modifications to the experimental details of the crumpling experiment above:

1. __Recording duration__. Does a longer or shorter recording duration change the distribution of event energies.
2. __Paper type__. Repeat the experiment with a different type of paper (thickness, material, ...)
3. __Hand size/shape, crumpling technique__. Repeat with a different person or crumpling strategy.

Pick a modification from the three categories above, and repeat the experiment making this modification.
Use `hold('on')` to plot both the original experiment and your modification on the same plot.
How did the experimental change affect your results?

---

### Tectonic Rubbing
The Earth responds with violent and intermittent earthquakes as two tectonic plates rub past one another.
The energy radiated by all earthquakes in 1995 is contained in the file `earthquakes.wav`.
Can you discern a 'crackle' (indicative of a scale-free distribution) from listening to the file?
(_Hint_: You can slow down the audio playback, e.g., by setting `fs = 2205`).

![](img/earthquake.gif)

Calculate the distribution of earthquake magnitudes.

You should find a power-law, as earthquakes come in a wide range of sizes, from common unnoticeable trembles to rare catastrophic events.
This relationship is called the Gutenberg–Richter law, which states that the earthquake magnitude scales with the logarithm of the magnitude of the earthquake.

:question::question::question:
What is the power-law exponent of the distribution of earthquake magnitudes?

<!-- and reproduce the two figures shown above. Upload your figures. -->

### Universality
Recall the concept of universality from lectures.

In this tutorial, we found a similar distribution of events across multiple decades of scale, in both earthquakes and paper crackling, despite both systems having vastly different physics.
Do earthquakes and paper crackling belong to the same universality class?


## Part 2: Self-organizing forests :evergreen_tree::fire::evergreen_tree::fire::evergreen_tree::fire::evergreen_tree:

Despite the complexities in how forest fires propagate (different trees, landscapes, and temperature), forest burn areas exhibit scale invariant power-law statistics (there are many small fires and few large fires).

![](img/forestFireAmazon.png)

### A simple forest-fire model
In lectures, we learned that the theory of self-organized criticality can explain the ubiquity of scale-invariance in natural systems.
We played with a [simple, interactive forest-fire model](https://www.complexity-explorables.org/explorables/critically-inflammatory/) that we're now going to implement and quantitatively analyze ourselves.

![](img/explorableForestFire.png)

One of the originators of the idea of self-organized criticality, Per Bak, developed a forest-fire model defined on a 2-dimensional spatial grid.

Initially, each site is randomly assigned to be a tree, a burning tree, or empty.
The system is then updated (in parallel) according to the following rules:
1. _Death_: A burning tree becomes an empty site in the next time-step;
2. _Regrowth_: An empty site grows a tree with probability `p`, and
3. _Burning_: A tree becomes a burning tree in the next time-step if at least one of its neighbours is burning.
4. _Lighting strike_: A tree becomes a burning tree during a time step with probability `f` if no neighbour is burning (this rule was required for the system to become truly critical).

We will examine this simple forest-fire model, demonstrating that it self-organizes to criticality and exhibits scale-invariant statistics.

:fire::fire::crown::fire::fire: If you are up for the challenge and want to understand the mechanics of the model, follow the instructions in [`ImplementingForestFire.md`](ImplementingForestFire.md) and modify `forestFireModelEmpty.m` to build your own forest-fire model.

:snowflake::snowflake::snowflake::snowflake: If you are running short on time, we have implemented the four rules for you in `forestFireModel`.
Have a look through it and make sure you understand how the four rules outlined above have been implemented.

### Critical conditions on parameters `f` and `p`

In this model, an important criterion for criticality is that lightning strikes at a rate `f`<<`p`.
In this case, the burning of a cluster of trees can be thought of as instantaneous, as long as the regrowth rate, `p` << 1 (small `p` prevents new trees growing at fire fronts).

Thus, the conditions for forest-fire criticality are that `f`<<`p`<<1.
Physically, these conditions can be interpreted as a separation of timescales: the time in which a forest cluster burns down (1) is much shorter than the time in which a tree grows (1/`p`), which is itself much shorter than the time between two lightning strikes (1/`f`).

Considering the timescales on which these phenomena occur within nature, discuss within your group whether you believe that this is a valid condition for simulating natural forest fires?

### Simulating forest-fire dynamics
In their original 1992 paper, Drossel and Schwabl simulated a grid-size of 250 x 250 over many hours.
Thankfully, computers are much faster now: we can comfortably model on a 300 x 300 grid and in a regime much closer to criticality (smaller `p`) in a few minutes.

For our simulations, we will be using the `ForestFireModel` code provided (or written, for those of you who are on :fire:).

```matlab
ForestFireModel(Tmax, PG, PL, plotFlag, outputFlag):
```
Inputs:
* `Tmax`: the number of generations to be simulated.
* `PG`: a multiplier of the critical growth rate.
* `PL`: a multiplier of the critical lightning rate.
* `plotFlag`: whether to plot the forest fire model (green = trees, white = empty ground, red = fire),
* `outputFlag`: whether to output a 3d matrix (space, space, time).

Let’s visualize the model dynamics at the critical point (`PG = 1`, `PL = 1`).
At the critical point, we expect to see a scale-free distribution of fire sizes.
Run the model at the critical point for 1000 generations, with plotting enabled.

Now examine the model when it is shifted from the critical regime by decreasing the lightning probability, `f` below the critical regime (`PL = 0.05`) and then increasing the lightning probability beyond the critical regime (`PL = 50`).

Remember how the creases in the paper crackling experiment occurred along spatially contiguous stretches of weak paper fibres, which are distributed as a power-law.
Discuss how the topographic structure of the forests (clusters of trees) at the critical point (`PL = 1`) differs from that at `PL = 0.05` and `PL = 50`.
Are they homogenous, heterogeneous, or something in between?
(_Hint:_ Do we see any qualitative evidence of scale-invariance?)

### Demonstrating criticality
In this section, we will quantitatively analyze the forest-fire dynamics to demonstrate that the model reaches a critical point.

First, let's extend the number of generations to 5000 (or more if time permitting) to build sufficient statistics, and save the output in the variable `data` (ensuring `outputFlag = true`).
Second, let's process the results using the `fireArea` function, to compute the number of trees burned in each fire as `treeBurn`.

#### Critical point `PL = 1`
Setting `PL = 1`, plot the distribution of cluster sizes (in units of trees) on log-log axes.
As with crackling noise, use logarithmically-spaced bins (setting a suitable number of bins and filtering out empty bins as appropriate).
You may also wish to restrict the scale over which you perform your linear fit as some large outliers may have insufficient statistics due to the short simulation time.

:question::question::question:
What distribution best fits your event histogram?

The histogram of natural forest-fire sizes has a powerlaw exponent of -1.
At the critical point, what is the powerlaw exponent of the distribution of forest-fire sizes in our model.
Does this super-simple model allow us to verify the empirical finding?

#### Subcritical: `PL = 50`

:question::question::question:
Are there more frequent smaller fires or larger fires?

:question::question::question:
What distribution best fits the forest-fire events?

#### Supercritical: `PL = 0.05`

:question::question::question:
Are there more smaller fires or larger fires in this regime?

:question::question::question:
What form best fits the distribution of forest-fire events?

### Physics as National Park Policy :evergreen_tree::fire::fire_engine:

Now that you are a world-leading expert on the dynamics of forest-fires, the Blue Mountains City Council has approached you and wants to know how to minimise large-scale fires.
Your colleague from UNSW suggests that the council should recruit more local fire-fighters during the bush-fire season to ensure that more small fires are extinguished quickly.

:question::question::question:
Does extinguishing small spot fires correspond to an increased or decreased `PL` in our model?

What regime does this correspond to in the model?

:question::question::question:
Should the council listen to the advice coming from UNSW?

(_Hint:_ Research 'The Yellowstone Effect'.)

:fire::fire::fire: (___Optional___):
The council are impressed with your work and have asked you to expand your model to incorporate fire-fighters and random-arsonists.
Implement these two new features into the model, and discuss the effect they have on forest-fire statistics.

---

## References

* Bak, Chen, and Tang, [A forest-fire model and some thoughts on turbulence](https://www.sciencedirect.com/science/article/pii/037596019090451S), _Physics Letters A_, **147**, 297-300 (1990).
* Drossel, B. and Schwabl, F. (1992),
[Self-organized critical forest-fire model](https://doi.org/10.1103/PhysRevLett.69.1629).
_Phys. Rev. Lett._ __69__, 1629–1632.
* Grassberger, P. (2002),
[Critical behaviour of the Drossel-Schwabl forest fire model](http://iopscience.iop.org/article/10.1088/1367-2630/4/1/317/meta).
_New J. Phys._ __4__, 17.
* Houle and Sethna (1996).
[Acoustic emission from crumpling paper](https://journals.aps.org/pre/abstract/10.1103/PhysRevE.54.278).
_Phys. Rev. E_
