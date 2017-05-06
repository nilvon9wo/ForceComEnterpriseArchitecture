# Developing with Source Control

## Prerequisites:
### Project Requirements
	* A Git repository, with at least the following folders
		* lib - For project dependencies, including
			* df12-deployment-tools
				* Available from https://github.com/financialforcedev/df12-deployment-tools/tree/master/lib
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

### Developer Requirements
	* Ant
	* Git

### Developer and Tester Project Initial Setup
	1. Developer creates a directory for the project, with two subdirectories:
		* REPO - For working with Ant and Git
		* WIP - For development work

	2. In the REPO directory:
		1. Clone from the git repository.
		2. Git checkout developer-latest branch.
		3. Delete folders within src directory, being careful to keep the package.xml
		4. Developer uses ant to pull files from DEV_LATEST into REPO
		5. Developer uses ant to push from local copy of DEV_LATEST (in REPO/src) to DEVA 
			 (for example, but each developer should have his/her own)  

### Developer Workflow
		
#### Before Starting Each Task		
	In the REPO directory:
	1. Developer uses ant to pull files from DEV_LATEST into REPO
	2. Developer uses ant to push from REPO/src to DEVA
	
#### For Each Task
	In the WIP directory:
	3. Developer develops feature/enhancements/fixes using tools of his/her choice.
		* If this work is local (e.g. using ForceIDE or Maven's Mate, file changes should only be in WIP).
		* Work should not be considered complete until it has been tested and automated tests have been created.
	
	4. Developer executes automated tests.
		* DO NOT PROCEED UNTIL ALL TESTS PASS. 
		
#### When the (sub)Task is COMPLETE and ALL TESTS are PASSING:
	5. Developer updates WIP/src/package.xml
		* As a best practice,
			- Individually list all members instead of using "*".
			- Keep the members alphabetically listed.
	6. Developer downloads metadata from DEVA to WIP/src
		* Even if he/she has worked locally, this should be done to ensure any manipulations, 
				such as reordering by SFDC and whitespace changes, by SFDC are captured.
	7. Developer uses ant to pull files from LATEST into REPO (again!)
	8. Developer creates new Git branch for his/her work (e.g., Feature/ABC-123 ).
	9. Developer MERGES (not copies) from  WIP/src to REPO/src.
	10. Developer uses ant to push from REPO/src to DEVA (for example, but each developer should have his/her own)
	11. Developer executes automate tests.
		* If there is anything to be fixed, go back to step 2.  

#### When ALL TESTS are PASSING:
	12. Developer uses git to commits and pushes Feature/ABC-123 to the repository
	13. Developer creates a pull request.
	14. At least one fellow developer performs a code review.
		* If there is anything to be fixed, go back to step 2.  

### Quality Assurance Workflow

#### Before Starting to Test each Task		
	In the REPO directory:
	15. Tester uses ant to pull files from DEV_LATEST into REPO
	16. Tester uses ant to push from REPO/src to TESTA (for example, but each tester should have his/her own)

#### For Each Task
	17. Tester used git to pull Feature/ABC-123 into REPO/src
	18. Tester uses ant to push from REPO/src to TESTA (for example, but each developer should have his/her own)
	19. Test executes both automated and manual tests on Feature/ABC-123
		* If there is anything to be fixed, go back to step 2.
			* Tester should provide DETAILED information regarding failure, including (as appropriate)
				1. Steps to reproduce
				2. Error messages
				3. Screen shots
				4. Logs  
	 
#### When ALL TESTS are PASSING:
	20. Tester merges from developer-latest into Feature/ABC-123 branch (again).
		* Developer who worked on task should help with this, if necessary.
	21. Tester uses git to commit and push changes in Feature/ABC-123.
	22. Tester uses ant to push from REPO/src to TESTA (for example, but each developer should have his/her own)
	23. Test executes both automated and manual tests on Feature/ABC-123
		* If there is anything to be fixed, go back to step 2.
			* Tester should provide DETAILED information regarding failure (as above)

#### If ALL TESTS are still PASSING, BUT ONLY WHEN JENKINS is GREEN:
	20. Tester merges from Feature/ABC-123 into developer-latest branch.
	21. Tester uses git to commits and push developer-latest branch.

#### Continuous Integration
	22. Jenkins has as a task to poll the Git developer-latest branch for changes (e.g. every 5 minutes).
		* Jenkins uses Ant to deploys from developer-latest to DEV_LATEST, running ALL the tests.
			* If the build breaks, there is a code freeze and no more code can be commited to developer-latest branch until the problem is resolved.
			* Whichever Developer/Tester pair broke the build have the immediate responsibility to investigate and fix the build.
			* In the event the issue can not be quickly resolved, the code must be reverted to its last green state.

	(No human should interact with the DEV_LATEST org.)

	24. Nightly, but only when the build is green, Jenkins will push updates from DEV_LATEST to the ALPHA environment.
	 	
#### Alpha (Internal/QA) Testing
	25. The Tester who pushed the change into the developer-latest branch shall retest in ALPHA.
	26. If there is anything to be fixed, go back to step 2.
			* Tester should provide DETAILED information regarding failure (as above)
	27. If all tests pass, the issue can be marked as "Resolved".

#### Beta (External/UAT) Testing
	28. Periodically, complete features should be manually pushed to BETA.
	29. Features should be tested by the end users (or their qualified proxies).
	29. If there is anything to be fixed, go back to step 2.
			* Tester should provide DETAILED information regarding failure (as above)

#### Production
	30. Periodically, complete features should be manually pushed to Production.
	31. Features should be tested by specially qualified end users authorized to view production data, authorized to make changes, 
		who understand the risks of making changes in production and how to mitigate them.
	32. If there is anything to be fixed, go back to step 2.
			* Tester should provide DETAILED information regarding failure (as above)
	33. If all tests pass, the issue can be marked as "Completed".

	(A deadline should be set against which, if no feedback is received, the features will be considered accepted, and the ticket closed.)


#### Continuous Delivery
	NOT recommended for Salesforce.com

### Resources:
	* Force.com Enterprise Architecture by Andrew Fawcett, Chapter 11: Source Control and Continuous Integration