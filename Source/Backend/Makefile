# See https://github.com/facebook/remodel
# Run npm install -g remodel-gen to install remodel-gen

all: IPFTestRunnerConfiguration.m

IPFTestRunnerConfiguration.m: IPFTestRunnerConfiguration.value
	remodel-gen IPFTestRunnerConfiguration.value

clean:
	rm IPFTestRunnerConfiguration.h IPFTestRunnerConfiguration.m

.PHONY: clean
