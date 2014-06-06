[![Build Status](http://img.shields.io/travis/rochefort/cocoapods-search.svg?style=flat)](http://travis-ci.org/rochefort/cocoapods-search)
[![Coverage Status](http://img.shields.io/coveralls/rochefort/cocoapods-search.svg?style=flat)](https://coveralls.io/r/rochefort/cocoapods-search)
[![Gem Version](http://img.shields.io/gem/v/cocoapods-search.svg?style=flat)](http://badge.fury.io/rb/cocoapods-search)

# cocoapods-search

cocoapods-search is a command line utitlity like cocoapod('pod search').  
You can see cocoapods with sorting by score on github.  

    Score = Star count + (Fork count * 5)

## Installation

Add this line to your application's Gemfile:

    gem 'cocoapods-search'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cocoapods-search

## Usage

Use the cocoapods-search as follows:
    pod-search `keyword'

e.g.:

```
$ pod-search chart
Name(Ver)                                 Score  Star  Fork
---------------------------------------- ------ ----- -----
PNChart (0.3.3)                            2635  1605   206
JBChartView (2.5.0)                        1885  1255   126
XYPieChart (0.2)                           1699   989   142
TEAChart (0.1)                              756   556    40
ios-linechart (1.3.0)                       619   359    52
EChart (0.1.1)                              462   312    30
FRD3DBarChart (1.1.1)                       423   208    43
JYRadarChart (0.3.1)                        283   178    21
NCICharts (2.0.1)                           226   171    11
Chartreuse (0.0.1)                          145   100     9
HUChart (1.0.0)                             132    97     7
YBStatechart (1.0.2)                         74    34     8
DSBarChart (0.4.0)                           63    33     6
SHPieChartView (1.0.3)                       24     9     3
TWRCharts (0.1)                              18    18     0
ChartboostSDK (4.2)                          15     0     3
BENPedometerChart (0.9.1)                     4     4     0
LFLineChartView (0.1.1)                       4     4     0
Chartbeat (0.0.1)                             1     1     0
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/cocoapods-search/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
