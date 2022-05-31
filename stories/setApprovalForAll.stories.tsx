import { ApproveAll } from './setApprovalForAll';
import { HyperverseProvider } from './utils/Provider';
import React from 'react';
import Doc from '../docs/setApprovalForAll.mdx';

export default {
	title: 'Components/ApproveAll',
	component: ApproveAll,
	parameters: {
		docs: {
			page: Doc,
		},
	},
};

const Template = (args) => (
	<HyperverseProvider>
		<ApproveAll {...args} />
	</HyperverseProvider>
);

export const Demo = Template.bind({});

Demo.args = {
	approveAll: {
		to: '',
		approved: true,
	},
};
