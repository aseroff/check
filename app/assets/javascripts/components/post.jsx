var Nices = React.createClass({
	render: function() {
		return (
			<div class='feed'>
				{this.props.post.map(function(post) { return (
					<div class='item'>

					</div>
				)})}
			</div>
		)
	}
});
