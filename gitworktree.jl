using LibGit2

function init_repo_and_create_worktree(main_repo_path::String, worktree_path::String, branch_name::String)
    # Initialize the main repository if it doesn't exist
    if !isdir(joinpath(main_repo_path, ".git"))
        println("Initializing new Git repository at $main_repo_path")
        repo = LibGit2.init(main_repo_path)
        
        # Create an initial commit
        LibGit2.commit(repo, "Initial commit")
    else
        repo = LibGit2.GitRepo(main_repo_path)
    end


		master = @edit LibGit2.lookup_branch(repo, "master")
		@show master
		println(master)
		println(typeof(master))
		if master === nothing
				error("Master branch not found")
		end

		head_commit = LibGit2.head(repo)
        
		# Create a new branch pointing to the current HEAD
		a = LibGit2.branch!(repo, branch_name, string(LibGit2.GitHash(head_commit)))
		@show a
		# Create a new branch from master
		println("Branch '$branch_name' created successfully")

		# Optionally, checkout the new branch
		# new_branch = LibGit2.lookup_branch(repo, branch_name)
		# LibGit2.checkout!(repo, LibGit2.target(new_branch))
		# println("Checked out branch '$branch_name'")

		run(`git worktree add $worktree_path $master`)
		println("Worktree created successfully at $worktree_path for branch $branch_name")
end

# Usage example
main_repo_path = "./"
worktree_path = "./worktree"
branch_name = "feature-br32anc3h4"

init_repo_and_create_worktree(main_repo_path, worktree_path, branch_name)