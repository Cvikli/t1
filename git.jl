
using LibGit2
using Dates

repo = LibGit2.init(".")
LibGit2.add!(repo, ".")

LibGit2.commit(repo, "Initial commit")


#%%
# Get an iterator for the commit history
walker = LibGit2.GitRevWalker(repo)
LibGit2.push_head!(walker)


# Iterate through the commits
for oid in walker
    @show oid
    commit = LibGit2.GitCommit(repo, oid)
    
    # Get commit information
    hash = string(oid)
    author = LibGit2.author(commit)
    message = LibGit2.message(commit)
    
    # Print commit info
    println("Commit: ", hash[1:7])
    println("Author: ", author.name, " <", author.email, ">")
    println("Date:   ", Dates.unix2datetime(author.time))
    println("    ", message)
    println()
end
