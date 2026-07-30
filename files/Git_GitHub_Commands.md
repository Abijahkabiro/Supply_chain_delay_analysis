# Git and GitHub Command Reference

A practical reference for moving your work between your computer and GitHub.

---

## The Difference Between Git and GitHub

**Git** is a tool on your computer that tracks changes to your files.
**GitHub** is a website that stores your files online so others can see them.

---

## One Time Setup

Run these once on any new computer before using Git.

```
git config --global user.name "Abijah Kabiro"
```
Sets your name so Git knows who is making changes.

```
git config --global user.email "your-email@gmail.com"
```
Sets your email linked to your GitHub account.

```
git config --list
```
Shows all your current Git settings.

---

## Starting a Project

```
git init
```
Initialises Git in your current folder. Run this once at the start of a new project.
Example: You create a new project folder and want Git to start tracking it.

```
git remote add origin https://github.com/username/repo-name.git
```
Connects your local folder to a GitHub repository.
Example: `git remote add origin https://github.com/Abijahkabiro/Supply_chain_delay_analysis.git`

```
git clone https://github.com/username/repo-name.git
```
Downloads a GitHub repo to your computer.
Example: `git clone https://github.com/Abijahkabiro/abijahkabiro.github.io.git`

---

## Checking What Has Changed

```
git status
```
Shows which files are new, modified or deleted since your last commit.
Example: Run this before every `git add` to see what you are about to stage.

```
git diff
```
Shows exactly which lines changed inside your files.
Example: Run this to see what you edited before committing.

```
git log --oneline
```
Shows a compact list of all past commits with their IDs and messages.
Example: `599f4f6 Initial commit: Supply Chain Delay Analysis`

```
git show --stat HEAD
```
Shows all files included in your most recent commit.
Example: Run this after committing to confirm the right files were included.

---

## Local to Online -- Pushing to GitHub

These 3 commands are your core push workflow. Use them every time.

```
git add .
```
Stages all changed files so they are ready to commit. The dot means everything.
Example: `git add .` to stage all files, or `git add README.md` to stage one file.

```
git commit -m "your message here"
```
Saves a snapshot of your staged files with a description of what changed.
Example: `git commit -m "Add Power BI dashboard and update README"`

```
git push origin master
```
Sends your committed changes to GitHub.
Example: `git push origin master` or `git push origin main` depending on your branch name.

```
git push -u origin master
```
Same as push but also sets up tracking so future pushes only need `git push`.
Example: Use this on your very first push from a new repo.

---

## Online to Local -- Pulling from GitHub

```
git pull origin master
```
Downloads the latest changes from GitHub and applies them to your local files.
Example: Run this before starting work if someone else may have pushed changes.

```
git fetch origin
```
Downloads changes from GitHub without applying them. Lets you review first.
Example: Run this to see what changed on GitHub before deciding to merge.

```
git clone https://github.com/username/repo-name.git
```
Downloads a complete copy of a repo including all its history.
Example: Use this when setting up on a new computer.

---

## Navigating Folders

```
cd "folder path"
```
Moves into a specific folder.
Example: `cd "C:\Users\abija\OneDrive\Documents\DATA ANALYTICS\DATA PROJECTS\1.Supply Chain"`

```
cd ..
```
Moves up one folder level.
Example: From inside the SQL folder, `cd ..` takes you back to the project root.

```
dir
```
Lists all files and folders in your current location.
Example: Run after navigating to confirm you are in the right place.

---

## Undoing Things

```
git restore filename
```
Discards changes to a file you have not committed yet.
Example: `git restore README.md` to throw away edits you do not want.

```
git restore --staged filename
```
Removes a file from staging without deleting your changes.
Example: `git restore --staged README.md` if you added a file by mistake.

```
git reset --soft HEAD~1
```
Undoes your last commit but keeps all the file changes.
Example: Use this if you committed too early and need to make more changes first.

---

## Ignoring Files

Create a file called `.gitignore` in your project folder. List anything you never want pushed to GitHub.

```
*.csv
*.xlsx
node_modules/
.env
Thumbs.db
```

Example: Add `DataCoSupplyChainDataset.csv` to .gitignore so the large raw data file never gets pushed.

---

## Common Errors and Fixes

| Error | Cause | Fix |
|---|---|---|
| src refspec main does not match any | Your branch is master not main | Use `git push origin master` |
| remote origin already exists | You already added the remote | Use `git remote set-url origin URL` instead |
| fatal: not a git repository | Git not initialised in this folder | Run `git init` or navigate to the right folder |
| failed to push some refs | GitHub has changes you do not have locally | Run `git pull origin master` first then push |
| LF will be replaced by CRLF | Windows line ending difference | Just a warning. Safe to ignore. |

---

## Your Standard Portfolio Push Workflow

```
cd "C:\Users\abija\OneDrive\Documents\DATA ANALYTICS\DATA PROJECTS\1.Supply Chain"
git status
git add .
git commit -m "describe what you changed"
git push origin master
```

Run these 5 commands in order every time you finish work and want to save it to GitHub.

