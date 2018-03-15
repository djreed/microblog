# Microblog

## Models
- Users
  - Email
  - Name
  - Handle
  - Description
- Follow
  - User being followed
  - User following
- Post
  - Content
  - User who posted/wrote

## Design

When logging in, enter a valid email or handle for one of the registered users to sign in as that user. When signed in, you can make, edit, and delete posts that you, as the user, have made. New users can be added through the "Users" button on th navbar, where you enter a unique email and handle, and optional name and description. Editting a user allows you to modify all of a user's fields, and is its own page.

Following functionality is such that you can view all posts for users you are following, and you can follow users from their user page, accessed through either the list of users or a link on one of their posts. Editting a post allows you to modify the content of the post, without modifying the id of the user the post is authored by.

Posts are made by logging in and pressing "new post" from the navbar, which leads to the post creation page. All posts can be accessed through "Posts", posts from users you follow can be accessed through "Home", and posts for a specific user can be found on that user's page (through any of their posts, or directly through "users").

Users and Posts are fully-fledged resources, though Posts do not have a 'show' endpoint, because there is no benefit (yet) to viewing a single post on its own. Users and Posts have controllers that handle routing, contexts that handle database retrieval, and html pages for each of the typical routes (index, show, create, edit, delete, etc., minus show for posts).

Follows have their own controller and context, but the only routes available are 'show/:id', which lists all followed users for the user id given, and 'index', which lists all posts from all users followed by the user logged in. If you are not logged in, 'index' routes to all posts instead.

I feel that, for an initial design, each feature is fleshed out quite well for this micro-blog, and the only things I could add are some convenience links here and there (get all followed users from a user's 'show' page, search functionality to search for users and posts by some keywords, removing the 'edit' and 'delete' from showing all users if that user is not you, etc.).

## Likes

Likes are a user-to-post join table, and are meant to signify that a user has liked a post.

The design is SUPPOSED to be such that liking a post increases that post's like count, and swaps the "like" button to "dislike" when you are logged in.

However, based on my website design and layout, I was unable to attach a unique like counter to each post independently (I got rid of the "show" page, which was my downfall at this point in the homework), and I was unable to implement a "dislike" as such.

With all this, I have the right infrastructure for "likes" to be implemented, but it would require a refactoring of how I'm showing posts.

## Deploy

The `deploy.sh` file is meant to be run on the local machine, and will start the deployed app on the remote server. In order, the app is compiled, sent as a gzipped tarball to the remote server, unpacked, and then rebooted through the new compiled binary.

On my local machine, run as `zsh` or `bash`: `zsh ./deploy.sh`
