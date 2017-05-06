# Developing with Source Control

This document attempts to describe an incredibly rebust SFDC version-control and deployment strategy.

## Prerequisites:

### Project Requirements
	* A Git repository, with at least the following folders
		* lib - For project dependencies, including
			* df12-deployment-tools
				* From df12-deployment-tools/lib (see resources)
				* Includes ant-salesforce.jar (i.e., The Salesforce.com Migration Tool)
		* src - For SFDC Metadata
	* At least one SalesForce developer sandboxes for each of the following:
		* One per developer (e.g. DEVA, DEVB, etc.)
		* One per tester (e.g. TESTA, TESTB, etc.)
		* One for latest build (DEV_LATEST)
		* One for alpha (internal/qa testing) (ALPHA)
		* One for beta (external/uat testing) (BETA)
	* A Jenkins server (for continuous integration)
		* Requires plugins for Ant, Git, and Salesforce Migration Tool.
		* Configuration is an advanced topic, not covered here.

### Developer and Tester Requirements
	* Ant
	* Git
	* A merge tool (e.g. Perforce or Kdiff3)
	* (recommended) ForceIDE (or any IDE which supports SFDC)

### Initial Project Setup
	1. Developer creates a directory for the project, with two subdirectories:
		* REPO - For working with Ant and Git
		* WIP - For development work, which should include the development of automated tests.

	2. In the REPO directory:
		1. With Git, _clone_ the git-repository.
		2. With Git, _checkout_ developer-latest branch.
		3. _Delete_ folders within src directory, being careful to *keep the package.xml*.
		4. With Ant, _retrieve_ files from DEV_LATEST sandbox into REPO folder.
		5. With Ant, _deploy_ from local copy of DEV_LATEST sandbox (in REPO/src folder) to DEVA sandbox. 
			 * (DEVA sandbox, for this example, but each developer should have his/her own sandbox.)  
			 
	3. In the WIP directory:
		6. With Git, _clone_ the git-repository.
		7. With Git, _create_ a new branch (e.g., sandbox/deva ).
		8. With Ant, _retrieve_ all metadata from DEVA sandbox.
		9. With Git, _add_, _commit_, and _push_ all files to sandbox/deva branch in git-repository.
		
		(sandbox/deva will never be merged, 
		but this will serve as a point of comparison when later debugging.)
		  			 

### Task Workflow
#### Developer Workflow
		
##### To Start Each Task		
	In the REPO directory:
	1. With Ant, _retrieve_ from DEV_LATEST sandbox. 
	2. With Ant, _deploy_ from REPO/src folder to DEVA sandbox.
		* Leveraging the df12-deployment-tools, it is possible to include
			* Cleaning the target org of old, unwanted data and metadata.
			* Executing arbitrary Apex functions, which may be used to load data into the environment
	
	In the WIP directory:
	3. With Git, _create_ a new branch (e.g., sandbox/deva/Feature/ABC-123 ).
	4. Develop feature/enhancements/fixes in the WIP directory and/or in the DEVA sandbox.
	5. With Git, frequently _commit_ changes to sandbox/deva/Feature/ABC-123 branch.
		* Ideally, each commit should be small, focused and logically complete, but not break tests.
	6. Solutions must not be considered complete appropriate automated tests have been created.
		* Depending how the team is specialized and organized, 
			* The task of writing tests may be passed to other developers and/or to testers.
			* The mechanics of such a workflow won't be detailed here, 
				but this process should be adapted so each still has his/her own sandbox.

		*A test which does not fail is NOT a test*

		* Automated tests should include:
			* Unit tests 
				- Tests to prove specific classes and methods function as expected.
				- If the code is clean code, these are the easiest to write.
				- These are the fastest to execute.
				- These are the most useful for regression and debugging.
				- These should be the majority of your tests.
				- Coverage should exceed at least 80% (yes, this exceeds SFDC requirements).
				- Coverage should include all "happy paths" and other significant branches.
			* Integration Tests 
				- Tests to prove that multiple units can work together
				- Tests to prove units work with user interfaces
				- Tests to prove units work with the intended database and external servers.
				- These must be included whenever the database or external systems are among the dependencies.
				- Coverage should include all "happy paths" and other significant branches.
			* End-to-End Tests (a.k.a. Acceptance Tests) 
				- Tests to prove the situations presented by User Stories can actually be accomplished.
				- These take the longest to execute and are the hardest to debug.
				- When possible use unit or integration tests to prove as much of the functionality as possible.
				- Coverage should include "happy paths" specifically given in User Stories.
				- Coverage should also prevent regression to any critical defects.
		* Coverage is a metric for understanding code quality.
			* Coverage is the byproduct of composing quality tests. 
				- Achieving coverage should not be the goal of writing tests.
				- It is only valuable to the extent developers understand what has been measured.
				- Code which bloats coverage metrics without providing value against regression 
					is fraudulent and -- for providing a false sense of security -- worse than useless.
							
					
	7. Executes all automated tests, both new and old.
		* Apex tests MUST PASS regardless how they are executed.
			* Note: Tests which are not carefully crafted may yield different results depending whether
				they are launched through Ant, through an IDE, or through an SFDC web session. 
	
	* DO NOT PROCEED UNTIL ALL TESTS PASS. 
		
##### When the (sub)Task is COMPLETE and ALL TESTS are PASSING:
	8. With Ant, _retrieve_ all metadata from DEVA sandbox.
		* Even if he/she has worked locally, this should be done to ensure any manipulations, 
				such as reordering by SFDC and whitespace changes, by SFDC are captured.
	9. With Git, _add_, _commit_, and _push_ all files to sandbox/deva/Feature/ABC-123 branch in git-repository. 
	
		(sandbox/deva/Feature/ABC-123 will never be merged, 
		but this will serve as a point of comparison when later debugging.)
	
	10. With Git, _checkout_ and _pull_ developer-latest branch.
	11. With Git, _create_ a new branch in the REPO directory (e.g., readyToTest/Feature/ABC-123 ). 
	12. With Ant, _retrieve_ from DEV_LATEST into REPO directory (again!)
	13. Update the REPO/src/package.xml
		* As a best practice,
			- Individually list only desired members instead of using "*".
			- Keep the members alphabetically listed.
	14. Manually MERGE (not copy) from  WIP/src directory to REPO/src directory.
		* Do not merge sandbox/deva/Feature/ABC-123 to readyToTest/Feature/ABC-123
			because SFDC might include metadata you don't actually want. 
	
	15. With Ant, _deploy_ from REPO/src to DEVA sandbox.
	16. Developer executes all automated tests, both new and old (again).
	
	* If there is anything to be fixed, go back to step 4.  

##### When ALL TESTS are PASSING:
	17. With Git, _add_, _commit_, and _push_ readyToTest/Feature/ABC-123 to the git-repository.
	18. _Create_ a pull request.
	19. At least one other developer performs a code review.
		* Github has built in code review tools, but if this is not used, other solutions are available.
		
	* If there is anything to be fixed, go back to step 4.  

#### Quality Assurance Workflow

	Note: This workflow assumes the tester is not responsible for writing any automated tests 
		and that all such tests have already been created by the developers.
		
	If this is not the case -- that is to say, if the tester is developing automated tests -- 
		the above process should be adapted, treating the tester as another developer:
			i. Keeping separate directories for development work and merging/commiting work.
			ii. Performing development work in his/her own sandbox.
	

##### To Start Each Task		
	In the REPO directory:
	20. With Ant, _retrieve_ from DEV_LATEST sandbox. 
	21. With Ant, _deploy_ from REPO/src folder to TESTA sandbox
		- For example, but each tester should have his/her own.
	22. With Git, _pull_ readyToTest/Feature/ABC-123 branch into REPO/src directory.
	23. With Ant, _deploy_ from REPO/src to TESTA sandbox.
	24. Execute all tests, both new and old, automated and manual.
		
	* If there is anything to be fixed, go back to step 4.
		* Tester should provide DETAILED information regarding failure, including (as appropriate)
			1. Steps to reproduce
			2. Error messages
			3. Screen shots
			4. Logs  
	 
##### When ALL TESTS are PASSING:
	25. With Git, _checkout_ and _pull_ developer-latest branch.
	26. With Git, _merge_ merges from developer-latest branch into readyToTest/Feature/ABC-123 branch
		* Again, because the branch might be a bit stale by now.
		* Developer who worked on task should help with this, if necessary.
	27. With Git, _commit_ and _push_ changes in readyToTest/Feature/ABC-123 branch.
	28. With Ant, _deploy_ from REPO/src to TESTA sandbox.
	29. Executes all tests, both new and old, automated and manual (again)
	
	* If there is anything to be fixed, go back to step 4.
		* Tester should provide DETAILED information regarding failure (as above)

##### If ALL TESTS are still PASSING, BUT ONLY WHEN JENKINS is GREEN:
	30. With Git, _checkout_ and _pull_ developer-latest branch.
	31. Tester merges from Feature/ABC-123 into developer-latest branch.
		* Again, because the branch might be a bit stale by now.
		* (At the tester's discretion) If there have been any significant changes, deploy and repeat tests.
	32. Verify Jenkins is still green. 
	32. With Git, _commit_ and _push_ to developer-latest branch.

##### Continuous Integration
	33. Jenkins should have a task to poll the Git developer-latest branch for changes (e.g. every 5 minutes).
		* With Ant, Jenkins _deploys_ from developer-latest to DEV_LATEST sandbox, executing ALL the tests.
			* If the build breaks, there is a code freeze and no more code can be commited to developer-latest branch until the problem is resolved.
			* Whichever Developers/Testers worked on the branch which broke the build 
				have the immediate responsibility to investigate and fix the build.
			* In the event the issue can not be quickly resolved, the code must be reverted to its last green state.

	(Normally, humans should not interact with the DEV_LATEST org after it has been created, 
		but they may need to in order to investigate broken builds.)

	34. Jenkins should have a _deploy_ from developer-latest to ALPHA sandbox on a regular basis (e.g. nightly)
		* This task should ONLY execute when the build is GREEN.
	 	
##### Alpha (Internal/QA) Testing
	35. Tester who pushed the change into the developer-latest branch shall retest in ALPHA.
	
	* If there is anything to be fixed, go back to step 4.
		* Tester should provide DETAILED information regarding failure (as above)

	36. If all tests pass, the issue can be marked as "Resolved" in the ticketing system.

##### Beta (External/UAT) Testing
	37. Periodically (as aligned to the project lifecycle), complete features should be manually _deployed_ to BETA sandbox.
		* Because SFDC deployments can be complicated and the environment itself quirk, automation here is entirely DISCOURAGED.
	38. Features should be tested by the end-users (or their qualified proxies, preferably on the client side).

	* If there is anything to be fixed, go back to step 4.
		* Tester should provide DETAILED information regarding failure (as above)

##### Production Testing
	37. Periodically (as aligned to the project lifecycle), complete features should be manually _deployed_ to PRODUCTION.
		* Because SFDC deployments can be complicated and the environment itself quirk, automation here is entirely DISCOURAGED.
	38. Features must be tested ONLY by specially-qualified end-users who meet all the following criteria:
			* Are authorized to view production data;
			* Are authorized to make changes in production data;
			* Understand the risks of making changes in production; and
			* Know how to mitigate the risks.

	* If there is anything to be fixed, go back to step 4.
		* Tester should provide DETAILED information regarding failure (as above)
			
	39. If all tests pass, the issue can be marked as "Completed".
		* To prevent tickets from remaining open forever, set a "drop dead" date, after which features are considered accepted, and the ticket closed.


## Resources:

### Git (Version Control)
	* Git Downloads, https://git-scm.com/downloads
	
	* An Intro to Git and GitHub for Beginners (Tutorial),
		http://product.hubspot.com/blog/git-and-github-tutorial-for-beginners
		
	* Git Branching - Basic Branching and Merging, https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging
	
	* How To Use Git, GitHub and the Force.com IDE with Open Source Labs Apps,
	 	https://developer.salesforce.com/blogs/labs/2011/04/how-to-use-git-github-force-com-ide-open-source-labs-apps.html

### Apache Ant (Build Tool)
	* The Apache Ant Project Binary Distributions, https://ant.apache.org/bindownload.cgi

	* Apache Ant - Tutorial, http://www.vogella.com/tutorials/ApacheAnt/article.html
		 	
	* Using the Force.com Migration Tool,
		https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_deploying_ant.htm
		
	* Financial Force Dev Deployment Tools, https://github.com/financialforcedev/df12-deployment-tools	 	
	
### Jenkins (Continuous Integration)
	* Getting Started with Jenkins, https://jenkins.io/download/ 
	
	* Continuous integration with Jenkins - Tutorial, http://www.vogella.com/tutorials/Jenkins/article.html
	
	* Setting Up Jenkins for Force.com Continuous Integration, 
		https://developer.salesforce.com/blogs/developer-relations/2013/03/setting-up-jenkins-for-force-com-continuous-integration.html

### Perforce (Merge and Diff Tools)
	* Visual Merge and Diff Tools, https://www.perforce.com/product/components/perforce-visual-merge-and-diff-tools
	
	* Dealing with Merge Conflicts, https://www.git-tower.com/learn/git/ebook/en/command-line/advanced-topics/merge-conflicts
	
### Testing
	* Test Pyramid, https://martinfowler.com/bliki/TestPyramid.html
	
	* Unit Testing, http://searchsoftwarequality.techtarget.com/definition/unit-testing
	
	* Integration Testing, https://msdn.microsoft.com/en-us/library/aa292128(v=vs.71).aspx
	
	* Just Say No to More End-to-End Tests, https://testing.googleblog.com/2015/04/just-say-no-to-more-end-to-end-tests.html
	
	* Software Testing, https://en.wikipedia.org/wiki/Software_testing
	
### Enterprise Development
	* Force.com Enterprise Architecture by Andrew Fawcett, Chapter 11: Source Control and Continuous Integration,
		https://www.packtpub.com/application-development/forcecom-enterprise-architecture
	
	