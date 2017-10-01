# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Microblog.Repo.insert!(%Microblog.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Microblog.Repo.insert!(%Microblog.Accounts.User{name: "David Reed", handle: "djreed", email: "ddavidreed@gmail.com", description: "This is my description. It is not too long, and not too short. There is much to it, and I enjoy existing. This is the final line of my description."})

Microblog.Repo.insert!(%Microblog.Accounts.User{name: "John Smith", handle: "jsmith", email: "john@example.com", description: "This is my description. It is not too long, and not too short. There is much to it, and I enjoy existing. This is the final line of my description."})

#Microblog.Repo.insert!(%Microblog.Blog.Post{user_id: 1, content: "DJReed Post Content 1"})
#Microblog.Repo.insert!(%Microblog.Blog.Post{user_id: 1, content: "DJReed Post Content 2"})
#Microblog.Repo.insert!(%Microblog.Blog.Post{user_id: 1, content: "DJReed Post Content 3"})
#Microblog.Repo.insert!(%Microblog.Blog.Post{user_id: 2, content: "JSmith Post Content 4"})
#Microblog.Repo.insert!(%Microblog.Blog.Post{user_id: 2, content: "JSmith Post Content 5"})
