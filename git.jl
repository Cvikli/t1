
using LibGit2
using Dates

# Initialize repo and make initial commit
repo = LibGit2.init(".")
LibGit2.add!(repo, ".")
LibGit2.commit(repo, "Initial commit")

# Create and switch to a new branch
LibGit2.branch!(repo, "new-feature")
LibGit2.checkout!(repo, "new-feature")

# Make changes and commit to the new branch
open("new_file.txt", "w") do file
    write(file, "This is a new file in the new-feature branch")
end
LibGit2.add!(repo, "new_file.txt")
LibGit2.commit(repo, "Add new file in new-feature branch")

# Function to display commit history
function display_commits(repo)
    walker = LibGit2.GitRevWalker(repo)
    LibGit2.push_head!(walker)

    for oid in walker
        commit = LibGit2.GitCommit(repo, oid)
        hash = string(oid)
        author = LibGit2.author(commit)
        message = LibGit2.message(commit)
        
        println("Commit: ", hash[1:7])
        println("Author: ", author.name, " <", author.email, ">")
        println("Date:   ", Dates.unix2datetime(author.time))
        println("    ", message)
        println()
    end
end

# Display commits in the new branch
println("Commits in 'new-feature' branch:")
display_commits(repo)

# Switch back to main branch
LibGit2.checkout!(repo, "main")

# Display commits in the main branch
println("\nCommits in 'main' branch:")
display_commits(repo)

