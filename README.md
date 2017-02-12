 # Project 1 - *Flicks*

**Flicks** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **10.20** hours spent in total

## User Stories

The following **required** functionality is complete:

- [x] User can view a list of movies currently playing in theaters from The Movie Database.
- [x] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [x] User sees a loading state while waiting for the movies API.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x] User sees an error message when there's a networking error.
- [ ] Movies are displayed using a CollectionView instead of a TableView.
- [ ] User can search for a movie.
- [ ] All images fade in as they are loading.
- [ ] Customize the UI.

The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. UIDesign
2. Ideas for other features

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='https://github.com/hlpostman/Flicks/blob/master/Flicks_Video_WalkThrough.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

I spent a few unsuccessful hours trying to build a details view controller. I will come back to that.  I also made outlines for fleshing out the visual of the network error message and may implement that and the search bar or collection view.  My networking error message shows if the network cannot be accessed on launch, but does not seem to recognize itself as a target of the pull-to-refresh, so if I turn the wifi back on and pull to refresh, I’m stuck at the network error.  Working on this.

## License

    Copyright 2017 H. L. Postman

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

# Project 2 - *Flicks*

**Flicks** is a movies app displaying box office and top rental DVDs using [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **17** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can view movie details by tapping on a cell.
- [x] User can select from a tab bar for either **Now Playing** or **Top Rated** movies.
- [x] Customize the selection effect of the cell.

The following **optional** features are implemented:

- [ ] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [ ] Customize the navigation bar.

The following **additional** features are implemented:

- [x] Homemade tab bar icons.
- [x] Implemented the search bar that was an optional last week with a case-insensitive prefix search
- [x] Customized detail view UI:
	- [x] Movie info scrolls over poster backdrop
	- [x] Movie overview is in fixed-size area, using its own scrollview to accommodate varying length descriptions
	- [x] Cast headshots and names appear in collection view
	- [x] Tap to dismiss info scroll view and reset the overview and cast collection views to original positions


Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Search methods
2. I wanted to make the tab bar scroll sideways to support additional endpoints.  I’d be interested in anything extra people did with the tab bar.

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='https://raw.githubusercontent.com/hlpostman/Flicks/master/Flicks_Video_WalkThrough2.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

I had some trouble getting my search bar to search in a way that was both case-insensitive AND prefix oriented.  But I came up with a solution :D  You can make both your `searchText` input and your compare strings (titles keyed to from the movie stats dictionary) both `lowercased()` when you invoke either in the `.hasPrefix` filtering routine.  I would like to improve the search functionality so that you can search for “lego” and get “The Lego Movie” even though “lego” is not the movie prefix, but in such a way that the search “rin” still only gives “Rings”, not “Rings” and “Miss Pereg*rin*e’s Home for Peculiar Children.”

## License

    Copyright 2017 H. L. Postman

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
